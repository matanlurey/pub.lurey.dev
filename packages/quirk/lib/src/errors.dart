/// Checks that an integer value is positive (greater than zero).
///
/// If [name] or [message] are provided, they are used as the parameter
/// name and message text of the thrown error. If [name] is omitted, it
/// defaults to `value`.
///
/// Returns [value] if it is not negative.
///
/// ## Example
///
/// ```dart
/// checkPositive(1); // 1
/// checkPositive(0); // Throws RangeError
/// checkPositive(-1); // Throws RangeError
/// ```
int checkPositive(int value, [String? name, String? message]) {
  if (value < 1) {
    throw RangeError.range(value, 1, null, name ?? 'value', message);
  }
  return value;
}
