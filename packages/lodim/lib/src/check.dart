part of '../lodim.dart';

/// Checks that an integer [value] is positive.
///
/// Throws if the value is not positive (either zero or negative).
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `value`.
///
/// Returns [value] if it is positive.
int checkPositive(int value, [String? name, String? message]) {
  if (value <= 0) {
    throw RangeError.value(
      value,
      name ?? 'value',
      message ?? 'must be positive',
    );
  }
  return value;
}

/// Checks that an integer [value] is positive.
///
/// If [assertions][] are enabled, throws if the value is not positive (either
/// zero or negative).
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `value`.
///
/// Returns [value] if it is positive, or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
int assertPositive(int value, [String? name, String? message]) {
  return _assertionsEnabled ? checkPositive(value, name, message) : value;
}

/// Checks that an integer [value] is non-negative.
///
/// Throws if the value is negative.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `index`.
///
/// Returns [value] if it is non-negative.
///
/// This method is identical to [RangeError.checkNotNegative] and is provided
/// for consistency.
int checkNonNegative(int value, [String? name, String? message]) {
  return RangeError.checkNotNegative(value, name ?? 'index', message);
}

/// Checks that an integer [value] is non-negative.
///
/// If [assertions][] are enabled, throws if the value is negative.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `index`.
///
/// Returns [value] if it is non-negative, or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
int assertNonNegative(int value, [String? name, String? message]) {
  return _assertionsEnabled ? checkNonNegative(value, name, message) : value;
}
