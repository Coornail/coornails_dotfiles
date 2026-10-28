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

tab=$(printf '\t')
checked=0
failed=0

while IFS="$tab" read -r name url ref sha license path fetched; do
  case "$name" in
    ''|\#*) continue ;;
  esac
  checked=$((checked + 1))

  if [ ! -f "$path" ]; then
    printf 'MISSING  %s (%s)\n' "$name" "$path"
    failed=$((failed + 1))
    continue
  fi

  actual=$(hash_file "$path")
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
