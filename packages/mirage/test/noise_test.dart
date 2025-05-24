import 'package:chaos/chaos.dart';
import 'package:mirage/mirage.dart';

import 'src/prelude.dart';

void main() {
  test('white noise', () {
    final random = SequenceRandom([0.0, 0.5, 1.0]);
    final pattern = White(random);

    check(pattern.get2d(0, 0)).equals(-1.0);
    check(pattern.get2d(0, 0)).equals(0.0);
    check(pattern.get2d(0, 0)).isCloseTo(1.0, 0.0001);
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
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
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
      -0.4193548387096774,
      -0.6129032258064516,
      -0.12903225806451613,
      -0.22580645161290325,
      -0.06451612903225812,
      -0.7419354838709677,
      -0.19354838709677402,
      -0.6774193548387095,
      -0.903225806451613,
      -0.4516129032258063,
      -0.7741935483870966,
      -0.8387096774193548,
      -0.5161290322580641,
      -0.38709677419354804,
      -0.12903225806451601,
      -0.25806451612903203,
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
      0.15294117647058814,
      -0.19215686274509802,
      0.7490196078431373,
      0.5529411764705883,
      0.8274509803921568,
      -0.45882352941176474,
      0.615686274509804,
      -0.35686274509803917,
      -0.7647058823529411,
      0.08235294117647052,
      -0.5529411764705883,
      -0.6705882352941177,
      -0.0117647058823529,
      0.19999999999999996,
      0.7176470588235293,
      0.48235294117647065,
    ]);
  });
}
