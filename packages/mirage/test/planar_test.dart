import 'package:chaos/chaos.dart';
import 'package:mirage/mirage.dart';

import 'src/prelude.dart';

void main() {
  test('planar + value', () {
    final random = SequenceRandom([0.0, 0.5, 1.0]);
    final value = Value(NoiseTable(random));
    final planar = buildFlatPlane(
      3,
      3,
      value.get2df,
    );

    check(planar.values).deepEquals([
      -959.9333333333334,
      -959.9333333333334,
      28.67843137254902,
      -959.9333333333334,
      -959.9333333333334,
      28.67843137254902,
      -1.6901960784313725,
      -1.6901960784313725,
      -0.9372549019607843,
    ]);
  });

  test('planar + value (seamless)', () {
    final random = SequenceRandom([0.0, 0.5, 1.0]);
    final value = Value(NoiseTable(random));
    final planar = buildFlatPlane(
      3,
      3,
      value.get2df,
      seamless: true,
    );

    check(planar.values).deepEquals([
      -0.9607843137254902,
      -1.130718954248366,
      0.5398692810457517,
      9.488888888888887,
      -100.6601307189542,
      -9.020915032679738,
      -1.3111111111111111,
      -4.620043572984748,
      -3.2997821350762524,
    ]);
  });
}
