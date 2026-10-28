#!/bin/sh
# Recompute the sha256 of every vendored source recorded in SOURCES.lock.
# Exits non-zero on any missing file or hash mismatch, so `make verify` fails.
#
# Runs under a POSIX shell on Linux and macOS; sha256sum is Linux, macOS ships
# shasum instead.
set -eu

cd "$(dirname "$0")/.."

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  else
    shasum -a 256 "$1" | cut -d' ' -f1
  fi
}

hash_stdin() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | cut -d' ' -f1
  else
    shasum -a 256 | cut -d' ' -f1
  fi
}

# Directory rows carry a tree hash: the sha256 of one
# "<file sha256>  <path relative to the directory>" line per regular file,
# sorted bytewise, with compiled *.zwc files left out (gitignored build
# artifacts, never committed). Reproduce a row by hand with:
#   (cd sources/<name> && find . -type f ! -name '*.zwc' | LC_ALL=C sort \
#      | while read -r f; do printf '%s  %s\n' "$(sha256sum "$f" | cut -d' ' -f1)" "${f#./}"; done) | sha256sum
tree_hash() {
  (
    cd "$1" || exit 1
    find . -type f ! -name '*.zwc' ! -path './.git/*' | LC_ALL=C sort |
      while IFS= read -r f; do
        printf '%s  %s\n' "$(hash_file "$f")" "${f#./}"
      done
  ) | hash_stdin
}

tab=$(printf '\t')
checked=0
failed=0

while IFS="$tab" read -r name url ref sha license path fetched; do
  case "$name" in
    ''|\#*) continue ;;
  esac
  checked=$((checked + 1))

  if [ -d "$path" ]; then
    actual=$(tree_hash "$path")
  elif [ -f "$path" ]; then
    actual=$(hash_file "$path")
  else
    printf 'MISSING  %s (%s)\n' "$name" "$path"
    failed=$((failed + 1))
    continue
  fi

  if [ "$actual" != "$sha" ]; then
    printf 'DRIFT    %s (%s)\n' "$name" "$path"
    printf '         expected %s\n' "$sha"
    printf '         actual   %s\n' "$actual"
    failed=$((failed + 1))
  else
    printf 'ok       %s @ %s\n' "$name" "$(printf '%s' "$ref" | cut -c1-12)"
  fi
done < SOURCES.lock

if [ "$checked" -eq 0 ]; then
  printf 'SOURCES.lock has no rows\n'
  exit 1
fi

printf '%d source(s) checked, %d failing\n' "$checked" "$failed"
[ "$failed" -eq 0 ]
