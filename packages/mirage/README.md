<!-- #region(HEADER) -->
# `mirage`

Generate noise and patterns algorithmically for use in software, textures, and
graphics.

| ✅ Health | 🚀 Release | 📝 Docs | ♻️ Maintenance |
|:----------|:-----------|:--------|:--------------|
| [![Build status for package/mirage](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_mirage.yaml/badge.svg)](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_mirage.yaml) | [![Pub version for package/mirage](https://img.shields.io/pub/v/mirage)](https://pub.dev/packages/mirage) | [![Dart documentation for package/mirage](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/mirage) | [![GitHub Issues for package/mirage](https://img.shields.io/github/issues/matanlurey/pub.lurey.dev/pkg-mirage?label=issues)](https://github.com/matanlurey/pub.lurey.dev/issues?q=is%3Aopen+is%3Aissue+label%3Apkg-mirage) |
<!-- #endregion -->

## Usage

An example of generating a Simplex noise pattern:

![Simplex](https://github.com/user-attachments/assets/5168bc86-9915-4664-ae8d-3752e2bd3651)

```dart
import 'package:mirage/mirage.dart';

void main() {
  final noise = Simplex();
  for (var y = 0; y < 256; y++) {
    for (var x = 0; x < 256; x++) {
      final value = noise.get2d(x, y);
      // Do something with the value...
    }
  }
}
```

For a full example, see the [example](./example) directory.

## Features

- Full implementations of popular 2D noise functions.
- Simple and predictable API for generating noise patterns.
- Build your own generator functions with the `Pattern2d` interface.
- Thoughtfully tested and documented for ease of use.

<!-- #region(CONTRIBUTING) -->
## Contributing

We welcome contributions to this package!

Please [file an issue][] before contributing larger changes.

[file an issue]: https://github.com/matanlurey/pub.lurey.dev/issues/new?labels=pkg-mirage

This package uses repository specific tooling to enforce formatting, static analysis, and testing. Please run the following commands locally before submitting a pull request:

- `./dev.sh --packages packages/mirage check`
- `./dev.sh --packages packages/mirage test`

<!-- #endregion -->
