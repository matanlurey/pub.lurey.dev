import 'package:checks/checks.dart';
import 'package:checks/context.dart';

/// Additional assertions for [Object].
extension ObjectChecks on Subject<Object> {
  /// Extracts [Object.hashCode] for further expectations.
  Subject<int> get hasHashCode => has((t) => t.hashCode, 'hashCode');

  /// Extracts [Object.toString] for further expectations.
  Subject<String> get hasToString => has((t) => t.toString(), 'toString');

  /// Checks that the object is equivalent to the expected value.
  ///
  /// This is a shortcut for both [equals] and [hasHashCode] checks.
  void isEquivalentTo(Object? expected) {
    return context.expect(() => ['is equivalent to', ...literal(this)], (
      actual,
    ) {
      if (actual != expected) {
        return Rejection(which: ['are not equal']);
      }
      if (actual.hashCode != expected.hashCode) {
        return Rejection(
          which: [
            'hash codes are not equal',
            'actual: ${actual.hashCode}',
            'expected: ${expected.hashCode}',
          ],
        );
      }
      return null;
    });
  }
}
