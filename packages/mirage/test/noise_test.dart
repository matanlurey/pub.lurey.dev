import 'package:chaos/chaos.dart';
import 'package:mirage/mirage.dart';

import 'src/prelude.dart';

void main() {
  test('white noise', () {
    final random = SequenceRandom([0.0, 0.5, 1.0]);
    final pattern = White(random);

    check(pattern.get2d(0, 0)).equals(-1.0);
    check(pattern.get2d(0, 0)).equals(0.0);
    check(pattern.get2d(0, 0)).equals(1.0);
  });

  test('perlin noise', () {
    final pattern = Perlin(NoiseTable.fromSeed(0xDEADBEEF));

    // Generate an 4x4 grid of perlin noise values in a flat list.
    final grid = Iterable.generate(4 * 4, (i) {
      final x = i % 4;
      final y = i ~/ 4;
      return pattern.get2d(x, y);
    }).toList();

    check(grid).deepEquals([
      0.0, 0.0, 1.0, -1.0, //
      0.0, 0.0, 1.0, -1.0, //
      1.0, -1.0, 1.0, 1.0, //
      1.0, 1.0, -1.0, -1.0, //
    ]);
  });

  test('simplex noise', () {
    final pattern = Simplex(NoiseTable.fromSeed(0xDEADBEEF));

    // Generate an 4x4 grid of simplex noise values in a flat list.
    final grid = Iterable.generate(4 * 4, (i) {
      final x = i % 4;
      final y = i ~/ 4;
      return pattern.get2d(x, y);
    }).toList();

    check(grid).deepEquals([
      0.0,
      -0.5392700671585607,
      -0.4578268503874004,
      0.16413724395993845,
      -0.5559791823237101,
      0.3564385613590572,
      0.16413724395993845,
      -0.48290735154820574,
      0.3564385613590574,
      -0.16413724395993845,
      0.39668592773889655,
      0.008964268261665142,
      0.0,
      0.0,
      0.2741438321751817,
      0.3209907104230883,
    ]);
  });

  test('value noise', () {
    final pattern = Value(NoiseTable.fromSeed(0xDEADBEEF));

    // Generate an 4x4 grid of value noise values in a flat list.
    final grid = Iterable.generate(4 * 4, (i) {
      final x = i % 4;
      final y = i ~/ 4;
      return pattern.get2d(x, y);
    }).toList();

    check(grid).deepEquals([
      0.15294117647058814,
      0.7490196078431373,
      -5.5254901960784295,
      -602.9764705882353,
      -0.7647058823529411,
      -0.5529411764705883,
      -4.31764705882353,
      -109.30588235294118,
      23.329411764705885,
      40.10588235294117,
      -84.12941176470565,
      10485.329411764706,
      -148.88235294117652,
      137.51764705882363,
      -3346.3411764705907,
      -321745.0705882353,
    ]);
  });

  test('worley distance', () {
    final pattern = Worley.distance(hasher: NoiseTable.fromSeed(0xDEADBEEF));

    // Generate an 4x4 grid of worley distance values in a flat list.
    final grid = Iterable.generate(4 * 4, (i) {
      final x = i % 4;
      final y = i ~/ 4;
      return pattern.get2d(x, y);
    }).toList();

    check(grid).deepEquals([
      -0.6129032258064516,
      1.0371165682383157,
      3.0742331364766313,
      4.604481352559873,
      0.6582085117775407,
      1.3290680007980256,
      3.1742733202728006,
      4.811015290561983,
      2.5161290322580645,
      3.33008723567222,
      4.659153167052308,
      5.428345139138658,
      4.0,
      4.385164807134504,
      5.812182268793711,
      6.830939996442804,
    ]);
  });

  test('worley value', () {
    final pattern = Worley.value(hasher: NoiseTable.fromSeed(0xDEADBEEF));

    // Generate an 4x4 grid of worley value values in a flat list.
    final grid = Iterable.generate(4 * 4, (i) {
      final x = i % 4;
      final y = i ~/ 4;
      return pattern.get2d(x, y);
    }).toList();

    check(grid).deepEquals([
      -0.19215686274509802,
      -0.19215686274509802,
      0.5529411764705883,
      0.12941176470588234,
      0.08235294117647052,
      0.615686274509804,
      0.615686274509804,
      0.12941176470588234,
      -0.0117647058823529,
      0.08235294117647052,
      -0.6705882352941177,
      0.9137254901960785,
      0.9921568627450981,
      0.9921568627450981,
      0.5372549019607844,
      0.9137254901960785,
    ]);
  });
}
