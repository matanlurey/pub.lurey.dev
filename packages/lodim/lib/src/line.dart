part of '../lodim.dart';

/// A function that returns positions along a line between [start] and [end].
///
/// Optionally, the line function can be configured with an [exclusive] flag
/// to either conditionally include or exclude the [end] position. This flag
/// is optional, and algorithms may choose to ignore it, so check the specific
/// implementation for details.
typedef Line = Iterable<Pos> Function(Pos start, Pos end, {bool exclusive});
