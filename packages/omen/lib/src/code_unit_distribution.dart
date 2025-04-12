import 'dart:math';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:omen/src/distribution.dart';

/// Random alphanumeric code points from the range `0-9`, `a-z`, and `A-Z`.
const alphanumeric = CodeUnitDistribution(
  '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
);

/// A [Distribution] that produces a random code point from a string.
final class CodeUnitDistribution with Distribution<int> {
  /// Creates a [CodeUnitDistribution] from a `const` string.
  const CodeUnitDistribution(
    @mustBeConst this._string, //
  ) : assert(_string.length > 0, 'Must have at least one code point');

  /// Creates a [CodeUnitDistribution] from a string.
  ///
  /// The string must not be empty.
  factory CodeUnitDistribution.from(String string) {
    if (string.isEmpty) {
      throw ArgumentError.value(
        string,
        'string',
        'Must have at least one code point',
      );
    }
    return CodeUnitDistribution._(string);
  }

  const CodeUnitDistribution._(this._string);
  final String _string;

  @override
  int sample(Random random) {
    final index = random.nextInt(_string.length - 1);
    return _string.codeUnitAt(index);
  }

  /// Returns a random string of the given [length] using `this` distribution.
  String sampleString(Random random, {required int length}) {
    final codeUnits = Uint16List(length);
    for (var i = 0; i < length; i++) {
      codeUnits[i] = sample(random);
    }
    return String.fromCharCodes(codeUnits);
  }
}
