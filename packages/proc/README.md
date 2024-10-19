<!-- #region(HEADER) -->
# `proc`

Run and manage OS processes with an extensible and testable API.

| ✅ Health | 🚀 Release | 📝 Docs | ♻️ Maintenance |
|:----------|:-----------|:--------|:--------------|
| [![Build status for package/proc](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_proc.yaml/badge.svg)](https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_proc.yaml) | [![Pub version for package/proc](https://img.shields.io/pub/v/proc)](https://pub.dev/packages/proc) | [![Dart documentation for package/proc](https://img.shields.io/badge/dartdoc-reference-blue.svg)](https://pub.dev/documentation/proc) | [![GitHub Issues for package/proc](https://img.shields.io/github/issues/matanlurey/pub.lurey.dev/pkg-proc?label=issues)](https://github.com/matanlurey/pub.lurey.dev/issues?q=is%3Aopen+is%3Aissue+label%3Apkg-proc) |
<!-- #endregion -->

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

<!-- #region(CONTRIBUTING) -->
## Contributing

We welcome contributions to this package!

Please [file an issue][] before contributing larger changes.

[file an issue]: https://github.com/matanlurey/pub.lurey.dev/issues/new?labels=pkg-proc

This package uses repository specific tooling to enforce formatting, static analysis, and testing. Please run the following commands locally before submitting a pull request:

- `./dev.sh check --packages packages/proc`
- `./dev.sh test --packages packages/proc`

<!-- #endregion -->
