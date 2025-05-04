part of '../builder.dart';

/// A builder for a [Value].
abstract interface class ValueBuilder<T extends Value> {
  /// Clears the contents of this builder.
  void clear();

  /// Returns a clone of this builder.
  ValueBuilder<T> clone();

  /// Returns the value contained in this builder and clears the builder.
  T take();

  /// Returns a copy of the contents of this builder.
  ///
  /// Leaves the contents of this builder unchanged.
  T build();
}

/// A builder for a [MapValue].
abstract mixin class MapValueBuilder implements ValueBuilder<MapValue> {
  /// Creates an empty [MapValueBuilder].
  factory MapValueBuilder() {
    return _MapValueBuilder({});
  }

  /// Creates a [MapValueBuilder] from an existing map.
  ///
  /// A clone of the map is created, and changes to the builder do not affect
  /// the map.
  factory MapValueBuilder.fromMap(Map<String, Value> initial) {
    return _MapValueBuilder(initial).clone();
  }

  /// Creates a [MapValueBuilder] from an existing value.
  ///
  /// A clone of the value is created, and changes to the builder do not affect
  /// the value.
  factory MapValueBuilder.fromValue(MapValue initial) {
    return _MapValueBuilder(initial.value).clone();
  }

  @override
  MapValueBuilder clone();

  /// Entries in the builder.
  Iterable<MapEntry<String, Value>> get entries;

  /// The number of entries in the builder.
  int get length => entries.length;

  /// Whether the builder is empty.
  bool get isEmpty => length == 0;

  /// Whether the builder is not empty.
  bool get isNotEmpty => length > 0;

  /// Adds a [key] and [value] to the builder.
  void addValue(String key, Value value);

  /// Adds a [key] and the contents of [builder] to the builder.
  ///
  /// [ValueBuilder.build] is called on [builder] to get the value. To avoid
  /// unnecessary copies on data that you trust to not change in unexpected
  /// ways, set [copy] to `false` to use [ValueBuilder.take] instead.
  void addBuilder(String key, ValueBuilder builder, {bool copy = true}) {
    addValue(key, copy ? builder.build() : builder.take());
  }

  /// Adds a [key] and boolean [value] to the builder.
  // ignore: avoid_positional_boolean_parameters
  void addBool(String key, bool value) {
    addValue(key, Value.bool(value));
  }

  /// Adds a [key] and double [value] to the builder.
  void addDouble(String key, double value) {
    addValue(key, Value.double(value));
  }

  /// Adds a [key] and int [value] to the builder.
  void addInt(String key, int value) {
    addValue(key, Value.int(value));
  }

  /// Adds a [key] and string [value] to the builder.
  void addString(String key, String value) {
    addValue(key, Value.string(value));
  }

  /// Adds a [key] and bytes [value] to the builder.
  ///
  /// The list is added as a [BytesValue] and is not copied. To avoid
  /// unnecessary copies on data that you trust to not change in unexpected
  /// ways, set [copy] to `false`.
  void addBytes(String key, ByteData value, {bool copy = true}) {
    if (copy) {
      final bytes = Uint8List.fromList(value.buffer.asUint8List());
      value = bytes.buffer.asByteData();
    }
    addValue(key, Value.bytes(value));
  }

  /// Adds a [key] and list [value] to the builder.
  ///
  /// The list is added as a [ListValue] and is not copied. To avoid unnecessary
  /// copies on data that you trust to not change in unexpected ways, set [copy]
  /// to `false`.
  void addList(String key, List<Value> value, {bool copy = true}) {
    addValue(key, Value.list(copy ? [...value] : value));
  }

  /// Adds a [key] and map [value] to the builder.
  ///
  /// The map is added as a [MapValue] and is not copied. To avoid unnecessary
  /// copies on data that you trust to not change in unexpected ways, set [copy]
  /// to `false`.
  void addMap(String key, Map<String, Value> value, {bool copy = true}) {
    addValue(key, Value.map(copy ? {...value} : value));
  }

  /// Returns an unmodifiable view of the builder as a [Map].
  ///
  /// If [clear] or [take] is called, the view will be invalidated.
  @doNotStore
  Map<String, Value> asMap();
}

final class _MapValueBuilder with MapValueBuilder {
  _MapValueBuilder(this._buffer);
  Map<String, Value> _buffer;

  @override
  void addValue(String key, Value value) {
    _buffer[key] = value;
  }

  @override
  Iterable<MapEntry<String, Value>> get entries => _buffer.entries;

  @override
  void clear() {
    _buffer = {};
  }

  @override
  MapValueBuilder clone() {
    final value = MapValue(_buffer);
    return _MapValueBuilder(value.clone().value);
  }

  @override
  MapValue take() {
    final value = MapValue(_buffer);
    clear();
    return value;
  }

  @override
  MapValue build() {
    return MapValue(_buffer).clone();
  }

  @override
  Map<String, Value> asMap() {
    return UnmodifiableMapView(_buffer);
  }
}

/// A builder for a [ListValue].
abstract mixin class ListValueBuilder implements ValueBuilder<ListValue> {
  /// Creates a [ListValueBuilder].
  ///
  /// If [initial] is provided, it will be used to initialize the builder, where
  /// changes to the builder immediately affect the list. To avoid this, use
  /// either the `fromList`, `fromValue`, or [clone] methods.
  factory ListValueBuilder([List<Value>? initial]) {
    return _ListValueBuilder(initial ?? []);
  }

  /// Creates a [ListValueBuilder] from an existing list.
  factory ListValueBuilder.fromList(List<Value> initial) {
    return _ListValueBuilder(initial).clone();
  }

  /// Creates a [ListValueBuilder] from an existing value.
  factory ListValueBuilder.fromValue(ListValue initial) {
    return _ListValueBuilder(initial.value).clone();
  }

  @override
  ListValueBuilder clone();

  /// Entries in the builder.
  Iterable<Value> get entries;

  /// The number of entries in the builder.
  int get length => entries.length;

  /// Whether the builder is empty.
  bool get isEmpty => length == 0;

  /// Whether the builder is not empty.
  bool get isNotEmpty => length > 0;

  /// Adds a [value] to the builder.
  void addValue(Value value);

  /// Adds a [builder] to the builder.
  ///
  /// [ValueBuilder.build] is called on [builder] to get the value. To avoid
  /// unnecessary copies on data that you trust to not change in unexpected
  /// ways, set [copy] to `false` to use [ValueBuilder.take] instead.
  void addBuilder(ValueBuilder builder, {bool copy = true}) {
    addValue(copy ? builder.build() : builder.take());
  }

  /// Adds a boolean [value] to the builder.
  // ignore: avoid_positional_boolean_parameters
  void addBool(bool value) {
    addValue(Value.bool(value));
  }

  /// Adds a double [value] to the builder.
  void addDouble(double value) {
    addValue(Value.double(value));
  }

  /// Adds an int [value] to the builder.
  void addInt(int value) {
    addValue(Value.int(value));
  }

  /// Adds a string [value] to the builder.
  void addString(String value) {
    addValue(Value.string(value));
  }

  /// Adds a bytes [value] to the builder.
  ///
  /// The list is added as a [BytesValue] and is not copied. To avoid
  /// unnecessary copies on data that you trust to not change in unexpected
  /// ways, set [copy] to `false`.
  void addBytes(ByteData value, {bool copy = true}) {
    if (copy) {
      final bytes = Uint8List.fromList(value.buffer.asUint8List());
      value = bytes.buffer.asByteData();
    }
    addValue(Value.bytes(value));
  }

  /// Adds a list [value] to the builder.
  ///
  /// The list is added as a [ListValue] and is not copied. To avoid
  /// unnecessary copies on data that you trust to not change in unexpected
  /// ways, set [copy] to `false`.
  void addList(List<Value> value, {bool copy = true}) {
    addValue(Value.list(copy ? [...value] : value));
  }

  /// Adds a map [value] to the builder.
  ///
  /// The map is added as a [MapValue] and is not copied. To avoid unnecessary
  /// copies on data that you trust to not change in unexpected ways, set [copy]
  /// to `false`.
  void addMap(Map<String, Value> value, {bool copy = true}) {
    addValue(Value.map(copy ? {...value} : value));
  }

  /// Returns an unmodifiable view of the builder as a [List].
  ///
  /// If [clear] or [take] is called, the view will be invalidated.
  @doNotStore
  List<Value> asList();
}

final class _ListValueBuilder with ListValueBuilder {
  _ListValueBuilder(this._buffer);
  List<Value> _buffer;

  @override
  void addValue(Value value) {
    _buffer.add(value);
  }

  @override
  Iterable<Value> get entries => _buffer;

  @override
  void clear() {
    _buffer = [];
  }

  @override
  ListValueBuilder clone() {
    final value = ListValue(_buffer);
    return _ListValueBuilder(value.clone().value);
  }

  @override
  ListValue take() {
    final value = ListValue(_buffer);
    clear();
    return value;
  }

  @override
  ListValue build() {
    return ListValue(_buffer).clone();
  }

  @override
  List<Value> asList() {
    return UnmodifiableListView(_buffer);
  }
}
