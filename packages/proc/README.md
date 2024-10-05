# proc

Run and manage OS processes with an extensible and testable API.

[![CI](https://github.com/matanlurey/proc.dart/actions/workflows/check.yaml/badge.svg)](https://github.com/matanlurey/proc.dart/actions/workflows/check.yaml)
[![Coverage Status](https://coveralls.io/repos/github/matanlurey/proc.dart/badge.svg?branch=main)](https://coveralls.io/github/matanlurey/proc.dart?branch=main)
[![Pub Package](https://img.shields.io/pub/v/proc.svg)](https://pub.dev/packages/proc)
[![Dartdoc reference](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/proc/latest/)

## Features

Most use cases of running processes are typically handled by importing and using
`dart:io` and using the `Process` class. However, the `proc` library provides a
more flexible and extensible API for running and managing processes.

- Setting default parameters for launching processes.
- Cross-platform APIs that do not require `dart:io`.
- Create and manage individual processes using `ProcessController`.
- Emulate a file system like environment using `ExecutableContainer`.

## Usage

```dart
import 'package:proc/proc.dart';

void main() async {
  final tool = p.join('tool', 'echo.dart');
  final host = ProcessHost();
  final proc = await host.start(tool, ['stdout']);
}
```

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
