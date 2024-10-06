#!/usr/bin/env sh

# A development script for managing this monorepo.
# Requires the Dart SDK to be installed.
#
# Usage:
#   ./dev.sh <command> [arguments]

# Fail fast.
set -e

# Needed because if it is set, cd may print the path it changed to.
unset CDPATH

# On Mac OS, readlink -f doesn't work, so follow_links traverses the path one
# link at a time, and then cds into the link destination and find out where it
# ends up.
#
# The returned filesystem path must be a format usable by Dart's URI parser,
# since the Dart command line tool treats its argument as a file URI, not a
# filename. For instance, multiple consecutive slashes should be reduced to a
# single slash, since double-slashes indicate a URI "authority", and these are
# supposed to be filenames. There is an edge case where this will return
# multiple slashes: when the input resolves to the root directory. However, if
# that were the case, we wouldn't be running this shell, so we don't do anything
# about it.
#
# The function is enclosed in a subshell to avoid changing the working directory
# of the caller.
function follow_links() (
  cd -P "$(dirname -- "$1")"
  file="$PWD/$(basename -- "$1")"
  while [[ -h "$file" ]]; do
    cd -P "$(dirname -- "$file")"
    file="$(readlink -- "$file")"
    cd -P "$(dirname -- "$file")"
    file="$PWD/$(basename -- "$file")"
  done
  echo "$file"
)

# Find the root of the monorepo.
DEV_SH_PATH="$(follow_links "${BASH_SOURCE[0]}")"

# The root is the parent directory of this script.
ROOT_DIR="$(dirname "$DEV_SH_PATH")"

# The development script is in "dev/bin/dev.dart".
DEV_DART="$ROOT_DIR/dev/bin/dev.dart"

# Run the development script in --resident mode.
exec dart run --resident "$DEV_DART" "$@"
