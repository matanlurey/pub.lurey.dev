import 'dart:collection';

import '../src/suite_map.dart';

void main() {
  _SplayTreeMapSuite().run();
}

final class _SplayTreeMapSuite extends MapSuite {
  _SplayTreeMapSuite() : super('SplayTreeMap');

  @override
  Map<K, V> newEmptyMap<K, V>() {
    return SplayTreeMap();
  }

  @override
  Map<K, V> newMapWith1kEntries<K, V>(Iterable<MapEntry<K, V>> items) {
    return SplayTreeMap<K, V>()..addEntries(items);
  }

  @override
  Map<K, V> newMapWillInsert1kItemsLazy<K, V>() {
    return SplayTreeMap<K, V>();
  }
}
