#!/usr/bin/env dart --enable-asserts

import 'dart:math';

import 'package:image/image.dart' as i;
import 'package:mirage/mirage.dart';
import 'package:path/path.dart' as p;

/// This script generates PNG previews for all patterns in the library.
///
/// ## Usage
///
/// ```sh
/// dart example/generate_pngs.dart [seed]
/// ```
void main(List<String> args) async {
  final Random random;
  if (args.isNotEmpty) {
    random = Random(int.parse(args.first));
  } else {
    random = Random(0xDEADBEEF);
  }

  final output = p.join('example', 'out');

  const width = 512;
  const height = 512;
  Future<void> generate(
    String name,
    Pattern2d Function(Random) generate,
  ) async {
    final planar = buildFlatPlane(
      width,
      height,
      generate(random).normalized.get2df,
      xBounds: (-5, 5),
      yBounds: (-5, 5),
    );
    final image = i.Image(width: width, height: height);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        // 0.0 = black, 1.0 = white
        final value = planar.get(x, y);
        final color = (value * 255).toInt();
        image.setPixel(x, y, i.ColorRgb8(color, color, color));
      }
    }
    await i.writeFile(p.join(output, '$name.png'), i.encodePng(image));
  }

  await generate('checkerboard', (_) => Checkerboard.odd);
  await generate('white_noise', White.new);
  await generate('value_noise', (r) => Value(NoiseTable(r)));
  await generate('perlin_noise', (r) => Perlin(NoiseTable(r)));
  await generate('simplex_noise', (r) => Simplex(NoiseTable(r)));
  await generate('worley_value', (r) => Worley.value(hasher: NoiseTable(r)));
  await generate(
    'worley_distance',
    (r) => Worley.distance(hasher: NoiseTable(r)),
  );
}
