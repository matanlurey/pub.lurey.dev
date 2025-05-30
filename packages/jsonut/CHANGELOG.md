<!-- #region(HEADER) -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- #endregion -->

## 0.4.1+4

- Bumped Dart to `^3.8.0`.

## 0.4.1+3

- Bumped Dart to `^3.7.0`.

## 0.4.1+2

- Move the package into a monorepo.

## 0.4.1

- **Performance**: Each `<JsonValue>` type now has a `parseUtf8` method to
  efficiently parse UTF-8 encoded JSON strings. This is useful for cases where
  the JSON string is already encoded as UTF-8, such as when reading from a file
  or network stream.

  ```dart
  final bytes = utf8.encode('{"name": "John Doe"}');
  final object = JsonObject.parseUtf8(bytes);
  ```

  See <https://github.com/dart-lang/sdk/issues/55996> for more information.

- **Bug fix**: In error messages, the type of the value is now included in the
  error message. This makes it easier to understand what went wrong when
  parsing. For example:

  ```dart
  final object = JsonObject.parse('{"name": "John Doe"}');

  // ERROR: Expected a JsonNumber, but got a JsonString.
  final age = object['name'].number();
  ```

- Added `<JsonObject>.convert` to make it convenient to parse multiple values
  from a JSON object:

  ```dart
  final object = JsonObject.parse('{"name": "John Doe", "age": 42}');
  final person = object.convert((o) {
    return Person(
      name: o['name'].as(),
      age: o['age'].as(),
    );
  });
  ```

- Added top-level `jsonNull` constant for convenience:

  ```dart
  final object = JsonObject.parse('{"name": null}');
  final name = object['name'];
  print(name == jsonNull); // true
  ```

- Added `JsonValue.parse` and `.parseUtf8` methods for type inference usage:

  ```dart
  final object = JsonValue.parse<JsonObject>('{"name": "John Doe"}');
  print(object['name'].string());
  ```

- Added `<JsonArray>.cast` and `<JsonObject>.cast` as more permisive methods
  that accept types of `T extends JsonValue` instead of `T extends JsonAny`,
  which is more permissive:

  ```dart
  final array = JsonArray([JsonObject({'name': 'John Doe'})]);
  final list = array.cast<JsonObject>();
  ```

  Added `<JsonObject>.['...'] = value` as well with similar behavior.

## 0.4.0

- **Breaking change**: `<JsonAny>.as` is now relaxed and will return `null` if
  the value is `null`, and also supports non-JSON primitive types for
  convenience:

  ```dart
  final object = JsonObject.parse('{"age": 13}');
  final age = object['age'].as<int>();
  ```

- **Breaking change**: `<JsonAny>.asOrNull` is also relaxed, and supports
  non-JSON primitive types for convenience:

  ```dart
  final object = JsonObject.parse('{"age": 13}');
  final age = object['age'].asOrNull<int>();
  ```

- **Breaking change**: Renamed `JsonBool` to `JsonBoolean` for consistency:

  ```diff
  - JsonBool(true);
  + JsonBoolean(true);
  ```

- Added methods to return common default values:
  - `<JsonAny>.boolOrFalse()`
  - `<JsonAny>.numberOrZero()`
  - `<JsonAny>.stringOrEmpty()`
  - `<JsonAny>.arrayOrEmpty()`
  - `<JsonAny>.objectOrEmpty()`

  ```dart
  final object = JsonObject.parse('{"name": "John Doe"}');
  final email = object['name'].stringOrEmpty();
  print(email); // ""
  ```

- Added `<Iterable<JsonValue>>.mapUnmodifiable` as a convenience extension to
  convert an iterable of any valid JSON value to an unmodifiable list of a
  discrete type:

  ```dart
  final JsonArray array = getArrayFromSomewhere();
  final listOfDogs = array.cast<JsonObject>().mapUnmodifiable(Dog.fromJson);

  // We now have a List<Dog> that is unmodifiable.
  ```

- Added `<JsonAny>.deepGetOrNull`:

  ```dart
  final object = JsonObject.parse('{"name": {"first": "John", "last": "Doe"}}');
  final firstName = object.deepGetOrNull(['name', 'first']).string();
  ```

- Added the interface class `ToJson`:

  ```dart
  class Dog implements ToJson {
    const Dog({required this.name, required this.age});
    final String name;
    final int age;

    @override
    JsonValue toJson() {
      return JsonObject({
        'name': name,
        'age': age,
      });
    }
  }
  ```

## 0.3.0

- **Breaking change**: Removed `JsonAny.tryFrom`, which was at best, confusing
  as it accepted a nullable value and returned a nullable value. Either use
  `JsonAny.from` or `as JsonAny`.

- **Breaking change**: `<JsonAny>.as<T>()` no longer is bound to `JsonValue`.
  This avoids cases where the type would be inferred as `Never` because it was
  something like `int`, which should be fine.

- Added `<JsonObject>.deepGet` to get nested values:

  ```dart
  final object = JsonObject.parse('{"name": {"first": "John", "last": "Doe"}}');
  final firstName = object.deepGet(['name', 'first']).string();
  ```

- Improved some error messages.

## 0.2.1

- Fixed a bug where `JsonArray`'s elements were `JsonValue` not `JsonAny`.

## 0.2.0

- Added `.as` and `.asOrNull` methods to `JsonAny` for inference casting:

  ```dart
  final class Employee {
    const Employee({required this.name});
    final String name;
  }

  final object = JsonObject.parse('{"name": "John Doe"}');
  final employee = Employee(name: object['name'].as());
  ```

- **Breaking change:** `<JsonAny>.{type}Or` renamed to `<JsonAny>.{type}OrNull`
  to better reflect the behavior of the method, and be idiomatic with other Dart
  APIs:

  ```diff
  - print(any.stringOr('name'));
  + print(any.stringOrNull('name'));
  ```

- **Breaking change:** `<JsonType>.parse` only throws a `FormatException` if the
  input is not valid JSON, and an `ArgumentError` if the input is not the
  expected type. This makes the behavior more consistent with other Dart APIs.

- **Breaking change:** Reduced the API of `JsonObject` to remove `.{type}()`
  methods in favor of just providing a custom `[]` operator tht returns
  `JsonAny` instances.

  ```diff
  - print(person.string('name'));
  + print(person['name'].string());
  ```

  Saving roughly ~2 characters per call wasn't worth the additional complexity.

## 0.1.0

- Initial development release.
