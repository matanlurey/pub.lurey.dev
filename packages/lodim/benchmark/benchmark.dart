import 'dart:math' as math;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:lodim/lodim.dart';

void main() {
  _BaselineAllocate100x100Points().report();
  _PosClassAllocate100x100Points().report();
  _Baseline100x100EuclidianDistance().report();
  _PosClass100x100EuclidianDistance().report();
  _Baseline100x100Rotations0to360().report();
  _PosClass100x100Rotations0to360().report();

  _PosClass100x100Lines().report();
}

final class _BaselineAllocate100x100Points extends BenchmarkBase {
  static const _name = 'Allocate 100x100 points: Baseline';
  _BaselineAllocate100x100Points() : super(_name);

  late List<(int, int)> points;

  @override
  void setup() {
    points = List.filled(10000, (0, 0));
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      for (var j = 0; j < 100; j++) {
        points[i * 100 + j] = (i, j);
      }
    }
  }

  @override
  void teardown() {
    points.shuffle();
  }
}

final class _PosClassAllocate100x100Points extends BenchmarkBase {
  static const _name = 'Allocate 100x100 points: Pos';
  _PosClassAllocate100x100Points() : super(_name);

  late List<Pos> points;

  @override
  void setup() {
    points = List.filled(10000, Pos.zero);
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      for (var j = 0; j < 100; j++) {
        points[i * 100 + j] = Pos(i, j);
      }
    }
  }

  @override
  void teardown() {
    points.shuffle();
  }
}

final class _Baseline100x100EuclidianDistance extends BenchmarkBase {
  static const _name = 'Euclidian 100x100 Distance: Baseline';
  _Baseline100x100EuclidianDistance() : super(_name);

  late List<num> distance;

  @override
  void setup() {
    distance = List.filled(10000, 0);
  }

  @override
  void run() {
    for (var y = 0; y < 100; y++) {
      for (var x = 0; x < 100; x++) {
        // Calculate distance squared from (0, 0) to (x, y).
        final result = x * x + y * y;
        distance[y * 100 + x] = result;
      }
    }
  }

  @override
  void teardown() {
    distance.shuffle();
  }
}

final class _PosClass100x100EuclidianDistance extends BenchmarkBase {
  static const _name = 'Euclidian 100x100 Distance: Pos';
  _PosClass100x100EuclidianDistance() : super(_name);

  late List<int> distance;

  @override
  void setup() {
    distance = List.filled(10000, 0);
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      for (var j = 0; j < 100; j++) {
        final result = Pos(i, j).distanceTo(Pos.zero);
        distance[i * 100 + j] = result;
      }
    }
  }

  @override
  void teardown() {
    distance.shuffle();
  }
}

final class _Baseline100x100Rotations0to360 extends BenchmarkBase {
  static const _name = 'Rotations 100x100 0 to 360: Baseline';
  _Baseline100x100Rotations0to360() : super(_name);

  late List<(double, double)> results;

  @override
  void setup() {
    results = List.filled(10000, (0.0, 0.0));
  }

  @override
  void run() {
    for (var y = 0; y < 100; y++) {
      for (var x = 0; x < 100; x++) {
        for (var k = 0; k < 360; k += 45) {
          // Rotate (x, y) by k degrees.
          final radians = k * math.pi / 180;

          final x2 = x * math.cos(radians) - y * math.sin(radians);
          final y2 = x * math.sin(radians) + y * math.cos(radians);
          results[y * 100 + x] = (x2, y2);
        }
      }
    }
  }

  @override
  void teardown() {
    results.shuffle();
  }
}

final class _PosClass100x100Rotations0to360 extends BenchmarkBase {
  static const _name = 'Rotations 100x100 0 to 360: Pos';
  _PosClass100x100Rotations0to360() : super(_name);

  late List<Pos> results;

  @override
  void setup() {
    results = List.filled(10000, Pos.zero);
  }

  @override
  void run() {
    for (var y = 0; y < 100; y++) {
      for (var x = 0; x < 100; x++) {
        for (var k = 0; k < 8; k++) {
          results[y * 100 + x] = Pos(x, y).rotate90(k);
        }
      }
    }
  }

  @override
  void teardown() {
    results.shuffle();
  }
}

final class _PosClass100x100Lines extends BenchmarkBase {
  static const _name = 'Lines 100x100: Pos';
  _PosClass100x100Lines() : super(_name);

  late List<List<Pos>> results;

  @override
  void setup() {
    results = List.filled(10000, []);
  }

  @override
  void run() {
    for (var y = 0; y < 100; y++) {
      for (var x = 0; x < 100; x++) {
        for (var k = 0; k < 8; k++) {
          results[y * 100 + x] = Pos(x, y).lineTo(Pos(100, 100)).toList();
        }
      }
    }
  }

  @override
  void teardown() {
    results.shuffle();
  }
}
