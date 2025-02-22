import 'dart:async';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:meta/meta.dart';

/// Obscures information from the compiler on how the object is used.
void _blackBox(Object? any) => Zone.current.runUnary((_) {}, any);

/// Base class for [Map] benchmarks.
abstract base class MapSuite {
  const MapSuite(this.name);

  /// Name of the benchmark suite.
  final String name;

  /// Runs the benchmark suite.
  @nonVirtual
  void run() {
    _EmptyStringIntMapBenchmark(name, this).report();
    _CreateMapWith1kStringIntEntriesBenchmark(
      name,
      this,
      List.generate(1000, (index) => MapEntry(index.toString(), index)),
    ).report();
    _IterateMapWith1kStringIntEntriesBenchmark(name, this).report();
    _Hash1kEntriesBenchmark(name, this).report();
    _RemoveEveryOtherEntry1KEntriesBenchmark(name, this).report();
  }

  /// Should return a new empty map.
  @protected
  Map<K, V> newEmptyMap<K, V>();

  /// Should return a new map with 1k items inserted during creation.
  @protected
  Map<K, V> newMapWith1kEntries<K, V>(Iterable<MapEntry<K, V>> items);

  /// Should return a new map which will have 1k items inserted after creation.
  @protected
  Map<K, V> newMapWillInsert1kItemsLazy<K, V>();
}

final class _EmptyStringIntMapBenchmark extends BenchmarkBase {
  final MapSuite _suite;
  _EmptyStringIntMapBenchmark(String name, this._suite)
    : super('$name:EmptyStringIntMap');

  @override
  void run() {
    _blackBox(_suite.newEmptyMap<String, int>());
  }
}

final class _CreateMapWith1kStringIntEntriesBenchmark extends BenchmarkBase {
  final MapSuite _suite;
  final List<MapEntry<String, int>> _items;
  _CreateMapWith1kStringIntEntriesBenchmark(
    String name,
    this._suite,
    this._items,
  ) : super('$name:CreateMapWith1kStringIntEntries');

  @override
  void run() {
    _blackBox(_suite.newMapWith1kEntries<String, int>(_items));
  }
}

final class _Hash1kEntriesBenchmark extends BenchmarkBase {
  final MapSuite _suite;
  _Hash1kEntriesBenchmark(String name, this._suite)
    : super('$name:Hash1kEntries');

  late Map<String, int> _map;

  @override
  void setup() {
    _map = _suite.newMapWith1kEntries<String, int>(
      List.generate(1000, (index) => MapEntry(index.toString(), index)),
    );
  }

  @override
  void run() {
    for (var i = 0; i < 1000; i++) {
      _blackBox(_map.containsKey(i.toString()));
    }
  }
}

final class _IterateMapWith1kStringIntEntriesBenchmark extends BenchmarkBase {
  final MapSuite _suite;
  _IterateMapWith1kStringIntEntriesBenchmark(String name, this._suite)
    : super('$name:IterateMapWith1kStringIntEntries');

  late Map<String, int> _map;

  @override
  void setup() {
    _map = _suite.newMapWith1kEntries<String, int>(
      List.generate(1000, (index) => MapEntry(index.toString(), index)),
    );
  }

  @override
  void run() {
    for (final entry in _map.entries) {
      _blackBox(entry);
    }
  }
}

final class _RemoveEveryOtherEntry1KEntriesBenchmark extends BenchmarkBase {
  final MapSuite _suite;
  _RemoveEveryOtherEntry1KEntriesBenchmark(String name, this._suite)
    : super('$name:RemoveEveryOtherEntry1kEntries');

  late Map<String, int> _map;
  late List<String> _keys;

  @override
  void setup() {
    _map = _suite.newMapWith1kEntries<String, int>(
      List.generate(1000, (index) => MapEntry(index.toString(), index)),
    );
    _keys = _map.keys.toList();
  }

  @override
  void run() {
    for (var i = 0; i < _keys.length; i += 2) {
      _map.remove(_keys[i]);
    }

    _blackBox(_map);
  }
}
