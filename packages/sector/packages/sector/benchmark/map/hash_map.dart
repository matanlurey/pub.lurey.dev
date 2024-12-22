import 'dart:collection';

import '../src/suite_map.dart';

void main() {
  _LinkedHashMapSuite().run();
}

final class _LinkedHashMapSuite extends MapSuite {
  _LinkedHashMapSuite() : super('HashMap');

  @override
  Map<K, V> newEmptyMap<K, V>() {
    return HashMap();
  }

  @override
  Map<K, V> newMapWith1kEntries<K, V>(Iterable<MapEntry<K, V>> items) {
    return HashMap<K, V>.fromEntries(items);
  }

  @override
  Map<K, V> newMapWillInsert1kItemsLazy<K, V>() {
    return HashMap<K, V>();
  }
}
