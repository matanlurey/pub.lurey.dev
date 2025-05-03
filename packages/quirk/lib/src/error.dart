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

/// Checks that an iterrable is not empty.
///
/// Throws if the iterable is empty.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `iterable`.
///
/// Returns [iterable] if it is not empty.
I checkNotEmpty<I extends Iterable<void>>(
  I iterable, [
  String? name,
  String? message,
]) {
  if (iterable.isEmpty) {
    throw ArgumentError.value(
      iterable,
      name ?? 'iterable',
      message ?? 'must not be empty',
    );
  }
  return iterable;
}

/// Checks that an iterrable is not empty.
///
/// If [assertions][] are enabled, throws if the iterable is empty.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `iterable`.
///
/// Returns [iterable] if it is not empty, or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
I assertNotEmpty<I extends Iterable<void>>(
  I iterable, [
  String? name,
  String? message,
]) {
  return assertionsEnabled ? checkNotEmpty(iterable, name, message) : iterable;
}

/// Checks that a string is not empty.
///
/// Throws if the string is empty.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `string`.
///
/// Returns [string] if it is not empty.
String checkStringNotEmpty(String string, [String? name, String? message]) {
  if (string.isEmpty) {
    throw ArgumentError.value(
      string,
      name ?? 'string',
      message ?? 'must not be empty',
    );
  }
  return string;
}

/// Checks that a string is not empty.
///
/// If [assertions][] are enabled, throws if the string is empty.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `string`.
///
/// Returns [string] if it is not empty, or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
String assertStringNotEmpty(String string, [String? name, String? message]) {
  return assertionsEnabled
      ? checkStringNotEmpty(string, name, message)
      : string;
}

final _startsOrEndsWithWhitespace = RegExp(r'^\s+|\s+$');

/// Checks that a string is not empty, excluding whitespace.
///
/// Throws if the string is empty or contains only whitespace.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `string`.
///
/// Returns [string] if it is not empty and contains non-whitespace characters.
String checkStringNotBlank(String string, [String? name, String? message]) {
  var isEmpty = string.isEmpty;
  if (!isEmpty && _startsOrEndsWithWhitespace.hasMatch(string)) {
    isEmpty = string.trim().isEmpty;
  }
  if (isEmpty) {
    throw ArgumentError.value(
      string,
      name ?? 'string',
      message ?? 'must not be empty or whitespace',
    );
  }
  return string;
}

/// Checks that a string is not empty, excluding whitespace.
///
/// If [assertions][] are enabled, throws if the string is empty or contains
/// only whitespace.
///
/// If [name] or [message] are provided, they are used as the parameter name and
/// message text of the thrown error. If [name] is omitted, it defaults to
/// `string`.
///
/// Returns [string] if it is not empty and contains non-whitespace characters,
/// or if assertions are disabled.
///
/// [assertions]: https://dart.dev/language/error-handling#assert
String assertStringNotBlank(String string, [String? name, String? message]) {
  return assertionsEnabled
      ? checkStringNotBlank(string, name, message)
      : string;
}
