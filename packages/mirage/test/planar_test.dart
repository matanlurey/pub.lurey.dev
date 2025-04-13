import 'package:chaos/chaos.dart';
import 'package:mirage/mirage.dart';

import 'src/prelude.dart';

void main() {
  test('planar + value', () {
    final random = SequenceRandom([0.0, 0.5, 1.0]);
    final value = Value(NoiseTable(random));
    final planar = buildFlatPlane(3, 3, value.get2df);

    check(planar.values).deepEquals([
      -1962.3882352941175,
      -1962.3882352941175,
      61.015686274509804,
      -1962.3882352941175,
      -1962.3882352941175,
      61.015686274509804,
      -0.4745098039215686,
      -0.4745098039215686,
      -0.9764705882352941,
    ]);
  });

  test('planar + value (seamless)', () {
    final random = SequenceRandom([0.0, 0.5, 1.0]);
    final value = Value(NoiseTable(random));
    final planar = buildFlatPlane(3, 3, value.get2df, seamless: true);

    check(planar.values).deepEquals([
      -0.9137254901960784,
      -1.9934640522875813,
      0.10588235294117665,
      9.520261437908495,
      -212.61917211328964,
      117.95599128540304,
      -1.797385620915033,
      4.565141612200435,
      -8.537254901960786,
    ]);
  });
}
