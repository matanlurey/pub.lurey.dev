part of '../lodim.dart';

/// A function that returns positions along a path between [start] and [end].
///
/// Optionally, the path function can be configured with an [exclusive] flag
/// to either conditionally include or exclude the [end] position (of which
/// the exact definition is implementation-specific; for example, for a line
/// path, it may refer to the last position of the line, while for a rectangular
/// path, it may refer to the last column and row of the rectangle).
typedef Path = Iterable<Pos> Function(
  Pos start,
  Pos end, {
  bool exclusive,
});

/// A function that returns positions along a path between `start` and `end`.
///
/// **Deprecated**: Use [Path] instead.
@Deprecated('Use `Path` instead.')
typedef Line = Path;
