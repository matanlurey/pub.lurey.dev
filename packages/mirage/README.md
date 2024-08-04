# Mirage

Generates noise and patterns algorithmically for use in software, textures, and graphics.

[![Mirage on pub.dev][pub_img]][pub_url]
[![Code coverage][cov_img]][cov_url]
[![Github action status][gha_img]][gha_url]
[![Dartdocs][doc_img]][doc_url]
[![Style guide][sty_img]][sty_url]

[pub_url]: https://pub.dartlang.org/packages/chaos
[pub_img]: https://img.shields.io/pub/v/mirage.svg
[gha_url]: https://github.com/matanlurey/mirage.dart/actions
[gha_img]: https://github.com/matanlurey/mirage.dart/actions/workflows/check.yaml/badge.svg
[cov_url]: https://coveralls.io/github/matanlurey/mirage.dart?branch=main
[cov_img]: https://coveralls.io/repos/github/matanlurey/mirage.dart/badge.svg?branch=main
[doc_url]: https://www.dartdocs.org/documentation/chaos/latest
[doc_img]: https://img.shields.io/badge/Documentation-mirage-blue.svg
[sty_url]: https://pub.dev/packages/oath
[sty_img]: https://img.shields.io/badge/style-oath-9cf.svg

## Usage

An example of generating a Simplex noise pattern:

![Simplex](https://github.com/user-attachments/assets/ec9c44c1-fe6d-4ae4-99cc-09527229797e)

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

## Contributing

To run the tests, run:

```shell
dart test
```

To check code coverage locally, run:

```shell
./chore coverage
```

To preview `dartdoc` output locally, run:

```shell
./chore dartodc
```
