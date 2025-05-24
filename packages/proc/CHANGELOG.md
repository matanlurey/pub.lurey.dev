<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.2.0+3

- Bumped Dart to `^3.8.0`.

## 0.2.0+2

- Fixed a bug where `ProcessRunMode` was ignored in the default implementation.
- Bumped Dart to `^3.7.0`.

## 0.2.0+1

- Move into a monorepo.

## 0.2.0

- `Proccess.complete(...)` is a convenience method for simple cases where a
  process should be considered to have emitted all of its output and exited
  (by default, successfully). This is useful for simple cases where you don't
  need to interact with the process while it is running.

- `ProcessController(processId: ...)` is now optional, and if omitted, a process
  ID in the range `0..32767` will be automatically assigned. This is not
  guaranteed to be unique; if you need to ensure uniqueness, you should provide
  a process ID explicitly.

## 0.1.0

- Clarify some of the documentation and examples.

## 0.1.0-alpha

- Initial release
