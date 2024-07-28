#!/usr/bin/env sh

set -e

echo "Installing chore.dart..."
dart pub global activate -sgit https://github.com/matanlurey/chore.dart.git --git-ref=8b252e7

echo "Checking chore.dart..."
dart pub global run chore --help > /dev/null
