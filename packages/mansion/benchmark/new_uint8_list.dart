import 'dart:io' as io;
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

/// Benchmark for creating a [Uint8List] from a list of bytes.
///
/// Shows that [Uint8List.new] is ~10x faster than [Uint8List.fromList].
void main() {
  _Uint8ListFromList().report();
  _Uint8ListWithLength().report();
}

final class _Uint8ListFromList extends BenchmarkBase {
  _Uint8ListFromList() : super('Uint8List.fromList');

  late Uint8List _list;

  @override
  void run() {
    _list = Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
  }

  @override
  void teardown() {
    // Use the list so it is not optimized away.
    _writeBytesAvoidDeopt(_list);
  }
}

final class _Uint8ListWithLength extends BenchmarkBase {
  _Uint8ListWithLength() : super('Uint8List.withLength');

  late Uint8List _list;

  @override
  void run() {
    final list = Uint8List(10);
    list[0] = 0;
    list[1] = 1;
    list[2] = 2;
    list[3] = 3;
    list[4] = 4;
    list[5] = 5;
    list[6] = 6;
    list[7] = 7;
    list[8] = 8;
    list[9] = 9;
    _list = list;
  }

  @override
  void teardown() {
    // Use the list so it is not optimized away.
    _writeBytesAvoidDeopt(_list);
  }
}

void _writeBytesAvoidDeopt(Uint8List list) {
  final tmpDir = io.Directory.systemTemp.createTempSync('nox.benchmark');
  final file = io.File(
    '${tmpDir.path}${io.Platform.pathSeparator}nox.benchmark',
  );
  file.writeAsBytesSync(list);
  file.deleteSync();
  tmpDir.deleteSync();
}
