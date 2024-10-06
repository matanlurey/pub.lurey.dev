import 'dart:io';
import 'dart:math';

import 'package:mansion/mansion.dart';

void main() async {
  stdout.writeln('4-Bit ANSI Colors');
  await writeTiles(tilesPerRow: 4, [
    for (final color in Color4.values) Tile(color, '$color'),
  ]);

  stdout.writeln();
  stdout.writeln('8-Bit ANSI Colors');
  await writeTiles(tilesPerRow: 16, [
    for (final color in Color8.values) Tile(color, '${color.index}'),
  ]);

  stdout.writeln();
  stdout.writeln('24-Bit ANSI Colors (Every 32nd Color)');
  await writeTiles(tilesPerRow: 8, [
    for (final color in Color24.generate(sample: 32))
      Tile(color, color.toRGB().toRadixString(16).padLeft(6, '0')),
  ]);
}

final class Tile {
  const Tile(this.color, this.name);

  /// Color of the tile.
  final Color color;

  /// Name of the tile.
  final String name;
}

/// Writes the tiles to the standard output wrapping at the terminal width.
Future<void> writeTiles(
  Iterable<Tile> tiles, {
  required int tilesPerRow,
}) async {
  final listTiles = List.of(tiles);
  final maxLength = listTiles.map((tile) => tile.name.length).reduce(max);

  var currentWidth = 0;
  for (final tile in tiles) {
    stdout.writeAnsiAll([
      SetStyles(Style.foreground(tile.color)),
      Print('██'),
      SetStyles.reset,
      Print(' '),
      Print(tile.name.padRight(maxLength)),
      Print(' '),
    ]);

    currentWidth++;

    if (currentWidth == tilesPerRow) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      stdout.writeln();
      currentWidth = 0;
    }
  }
}
