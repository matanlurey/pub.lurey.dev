@Tags(['ffi'])
@TestOn('posix')
library;

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../tool/ffi/xoshiro128p.dart' as xoshiro_128_plus;
import '../tool/ffi/xoshiro128pp.dart' as xoshiro_128_plus_plus;
import 'src/prelude.dart';
import 'src/xoshiro_pregen.dart';

/// Tests the C-implementation of the xoshiro128+ and xoshiro128++ PRNGs.
///
/// We don't export these in the Dart library, but they are used for testing
/// the Dart implementation.
void main() {
  group(
    '',
    _test,
    onPlatform: {'linux': Skip('Not currently supported on Linux')},
  );
}

void _test() {
  // Compile the C implementations of the PRNGs.
  setUpAll(() async {
    final process = await io.Process.start(
      p.join('tool', 'compile_ffi.dart'),
      const [],
      mode: io.ProcessStartMode.inheritStdio,
    );
    if (await process.exitCode != 0) {
      fail('Failed to compile');
    }
  });

  group('xoshiro128plus', () {
    setUp(() {
      xoshiro_128_plus.seed(Uint32List.fromList([1, 2, 3, 4]));
    });

    test('generates expected random numbers', () {
      check([
        for (var i = 0; i < 10; i++) xoshiro_128_plus.next(),
      ]).deepEquals(xoshiro128P$0_1_2_4$first10Integers);
    });

    test('jump, and then generate 10 random numbers', () {
      xoshiro_128_plus.jump();
      check([
        for (var i = 0; i < 10; i++) xoshiro_128_plus.next(),
      ]).deepEquals(xoshiro128P$0_1_2_4$jump$next10Integers);
    });

    test('long jump, and then generate 10 random numbers', () {
      xoshiro_128_plus.longJump();
      check([
        for (var i = 0; i < 10; i++) xoshiro_128_plus.next(),
      ]).deepEquals(xoshiro128P$0_1_2_4$longJump$next10Integers);
    });
  });

  group('xoshiro128plusplus', () {
    setUp(() {
      xoshiro_128_plus_plus.seed(Uint32List.fromList([1, 2, 3, 4]));
    });

    test('generates expected random numbers', () {
      check([
        for (var i = 0; i < 10; i++) xoshiro_128_plus_plus.next(),
      ]).deepEquals(xoshiro128PP$0_1_2_4$first10Integers);
    });

    test('jump, and then generate 10 random numbers', () {
      xoshiro_128_plus_plus.jump();
      check([
        for (var i = 0; i < 10; i++) xoshiro_128_plus_plus.next(),
      ]).deepEquals(xoshiro128PP$0_1_2_4$jump$next10Integers);
    });

    test('long jump, and then generate 10 random numbers', () {
      xoshiro_128_plus_plus.longJump();
      check([
        for (var i = 0; i < 10; i++) xoshiro_128_plus_plus.next(),
      ]).deepEquals(xoshiro128PP$0_1_2_4$longJump$next10Integers);
    });
  });
}
