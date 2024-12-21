// Used to make FFI names match the C names.
// ignore_for_file: avoid_private_typedef_functions

import 'dart:ffi' as ffi;
import 'dart:io' as io;
import 'package:ffi/ffi.dart' as ffi;
import 'package:path/path.dart' as p;

/// Returns the next random number using the xoshiro128plusplus algorithm.
int next() => _ffiNext();

/// Seeds the xoshiro128plusplus algorithm with the given seed.
void seed(List<int> seed) {
  if (seed.length != 4) {
    throw ArgumentError('Seed must be 4 bytes long');
  }
  final seedPointer = ffi.malloc<ffi.Uint32>(4);
  try {
    for (var i = 0; i < seed.length; i++) {
      seedPointer[i] = seed[i];
    }
    _ffiSeed(seedPointer);
  } finally {
    ffi.malloc.free(seedPointer);
  }
}

/// Jumps the xoshiro128plusplus algorithm
void jump() => _ffiJump();

/// Long jumps the xoshiro128plusplus algorithm.
void longJump() => _ffiLongJump();

final _lib = ffi.DynamicLibrary.open(
  p.absolute(
    p.join('third_party', 'xoshiro128plusplus', () {
      if (io.Platform.isMacOS) {
        return 'libxoshiro128plusplus.dylib';
      } else if (io.Platform.isLinux) {
        return 'libxoshiro128plusplus.so';
      } else if (io.Platform.isWindows) {
        return 'xoshiro128plusplus.dll';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }()),
  ),
);

typedef _CNextFn = ffi.Uint32 Function();
typedef _DartNextFn = int Function();
final _ffiNext = _lib.lookupFunction<_CNextFn, _DartNextFn>('next');

typedef _CSeedFn = ffi.Void Function(ffi.Pointer<ffi.Uint32> seed);
typedef _DartSeedFn = void Function(ffi.Pointer<ffi.Uint32> seed);
final _ffiSeed = _lib.lookupFunction<_CSeedFn, _DartSeedFn>('seed');

typedef _CJumpFn = ffi.Void Function();
typedef _DartJumpFn = void Function();
final _ffiJump = _lib.lookupFunction<_CJumpFn, _DartJumpFn>('jump');

typedef _CLongJumpFn = ffi.Void Function();
typedef _DartLongJumpFn = void Function();
final _ffiLongJump = _lib.lookupFunction<_CLongJumpFn, _DartLongJumpFn>(
  'long_jump',
);
