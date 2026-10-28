#!/bin/sh
# Install the third-party release binaries listed in DOWNLOADS.lock.
#
# Called from `make zsh` (best effort: a failure warns and the install goes on)
# and available as `make downloads` (strict: exits non-zero on any failure).
#
# For the row matching this machine's target it installs the binary to
# ${INSTALL_DIR}/<install_path> (INSTALL_DIR defaults to $HOME).
#
# Idempotent and offline-friendly: when the installed binary already matches
# the row's binary hash, nothing is downloaded. Otherwise the archive is
# fetched, checked against the row's archive hash, and the binary is streamed
# out of it and checked against the row's binary hash before it is installed.
#
# Runs under a POSIX shell on Linux and macOS; sha256sum is Linux, macOS ships
# shasum instead.
set -eu

cd "$(dirname "$0")/.."

INSTALL_DIR=${INSTALL_DIR:-${HOME:?INSTALL_DIR or HOME must be set}}

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

is_sha256() {
  [ ${#1} -eq 64 ] || return 1
  case "$1" in
    *[!0123456789abcdef]*) return 1 ;;
  esac
  return 0
}

host_target() {
  case "$(uname -s)" in
    Linux)
      case "$(uname -m)" in
        x86_64|amd64) printf 'linux-x86_64' ;;
        aarch64|arm64) printf 'linux-aarch64' ;;
        *) return 1 ;;
      esac
      ;;
    Darwin)
      case "$(uname -m)" in
        arm64|aarch64) printf 'darwin-arm64' ;;
        x86_64) printf 'darwin-x86_64' ;;
        *) return 1 ;;
      esac
      ;;
    *) return 1 ;;
  esac
}

# A missing or unreadable lock must never read as "nothing to do": some shells
# let the failed redirect below continue into the empty loop, which would exit 0
# having installed nothing.
if [ ! -f DOWNLOADS.lock ] || [ ! -r DOWNLOADS.lock ]; then
  printf 'DOWNLOADS.lock is missing or unreadable\n'
  exit 1
fi

if ! host=$(host_target); then
  printf 'unsupported platform (%s %s) - no downloads fetched\n' "$(uname -s)" "$(uname -m)"
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  printf 'curl is required to fetch downloads\n'
  exit 1
fi

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-downloads.XXXXXX")
trap 'rm -rf "$tmpdir"' EXIT
trap 'exit 1' INT TERM

tab=$(printf '\t')
rows=0
matched=0
failed=0

# The trailing `|| [ -n "${name:-}" ]` keeps a lock row whose last line has no
# newline from being silently skipped: `read` fails at EOF but still fills the
# variables, and without this the last row would never be installed.
while IFS="$tab" read -r name target version url asha bsha path || [ -n "${name:-}" ]; do
  case "$name" in
    ''|\#*) continue ;;
  esac
  rows=$((rows + 1))

  # Validate a row before it can steer a write: a shifted or hand-edited column
  # must fail loudly instead of comparing one field against another.
  if ! is_sha256 "$asha" || ! is_sha256 "$bsha"; then
    printf 'BADROW   %s - archive/binary sha256 missing or not 64 hex chars\n' "$name"
    failed=$((failed + 1))
    continue
  fi
  case "$path" in
    ''|/*|..|../*|*/..|*/../*)
      printf 'BADROW   %s - install path %s is not a relative path inside INSTALL_DIR\n' "$name" "$path"
      failed=$((failed + 1))
      continue
      ;;
  esac

  [ "$target" = "$host" ] || continue
  matched=$((matched + 1))

  dest="$INSTALL_DIR/$path"
  if [ -d "$dest" ]; then
    printf 'BADROW   %s - %s is a directory\n' "$name" "$dest"
    failed=$((failed + 1))
    continue
  fi
  # The shortcut needs the executable bit too: a correct-hash file the shell
  # cannot run is not installed, whatever the hash says.
  if [ -f "$dest" ] && [ -x "$dest" ] && [ "$(hash_file "$dest")" = "$bsha" ]; then
    printf 'ok       %s %s (already installed)\n' "$name" "$version"
    continue
  fi

  archive="$tmpdir/$name-$target.tar.gz"
  if ! curl -fsSL --connect-timeout 15 --max-time 300 --retry 2 -o "$archive" "$url"; then
    printf 'FETCH    %s %s\n' "$name" "$url"
    failed=$((failed + 1))
    continue
  fi

  actual=$(hash_file "$archive")
  if [ "$actual" != "$asha" ]; then
    printf 'DRIFT    %s %s archive\n' "$name" "$version"
    printf '         expected %s\n' "$asha"
    printf '         actual   %s\n' "$actual"
    failed=$((failed + 1))
    continue
  fi

  # Stream the binary out of the archive instead of unpacking the tree: no
  # directory layout to guess and no archive uid/gid to restore, which fails
  # when tar runs as root without CAP_CHOWN.
  member=$(tar -tzf "$archive" | grep -F "/$name" | head -1 || true)
  if [ -z "$member" ]; then
    printf 'MISSING  %s %s - archive holds no %s binary\n' "$name" "$version" "$name"
    failed=$((failed + 1))
    continue
  fi

  mkdir -p "$(dirname "$dest")"
  staged="$dest.download.$$"
  if ! tar -xzOf "$archive" "$member" > "$staged"; then
    printf 'EXTRACT  %s %s - %s\n' "$name" "$version" "$member"
    rm -f "$staged"
    failed=$((failed + 1))
    continue
  fi

  actual=$(hash_file "$staged")
  if [ "$actual" != "$bsha" ]; then
    printf 'DRIFT    %s %s binary\n' "$name" "$version"
    printf '         expected %s\n' "$bsha"
    printf '         actual   %s\n' "$actual"
    rm -f "$staged"
    failed=$((failed + 1))
    continue
  fi

  chmod 755 "$staged"
  mv "$staged" "$dest"
  if [ ! -x "$dest" ]; then
    printf 'INSTALL  %s %s - %s is not executable after install\n' "$name" "$version" "$dest"
    failed=$((failed + 1))
    continue
  fi
  printf 'ok       %s %s (installed to %s)\n' "$name" "$version" "$dest"
done < DOWNLOADS.lock

# Distinguish "the lock lists nothing for this host" (fine) from "the lock holds
# no data rows at all" (a broken lock). A row rejected before it could match the
# host leaves matched=0 with failed>0, so the failure count decides first.
if [ "$rows" -eq 0 ]; then
  printf 'DOWNLOADS.lock has no rows\n'
  exit 1
fi
if [ "$matched" -eq 0 ]; then
  printf 'no downloads listed for %s\n' "$host"
fi

printf '%d download(s) for %s, %d failing\n' "$matched" "$host" "$failed"
[ "$failed" -eq 0 ]
