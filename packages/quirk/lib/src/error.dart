/// Whether assertions are enabled.
bool get assertionsEnabled {
  var enabled = false;
  assert(enabled = true, 'Always true when assertions are enabled');
  return enabled;
}

/// Checks that an integer [value] is positive.
///
/// Throws if the value is not positive (either zero or negative).
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `value`.
///
/// Returns [value] if it is positive.
T checkPositive<T extends num>(T value, [String? name, String? message]) {
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
T assertPositive<T extends num>(T value, [String? name, String? message]) {
  return assertionsEnabled ? checkPositive(value, name, message) : value;
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
T checkNonNegative<T extends num>(T value, [String? name, String? message]) {
  if (value < 0) {
    throw RangeError.value(
      value,
      name ?? 'index',
      message ?? 'must be non-negative',
    );
  }
  return value;
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
T assertNonNegative<T extends num>(T value, [String? name, String? message]) {
  return assertionsEnabled ? checkNonNegative(value, name, message) : value;
}
