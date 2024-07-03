import 'package:sector/sector.dart';

/// Pretty prints the grid and returns it as a string.
Traversal<String, T> prettyPrint<T>({
  String Function(T)? format,
}) {
  return (grid) => GridImpl.debugString(grid, format: format);
}
