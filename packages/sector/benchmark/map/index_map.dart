import 'package:sector/src/collection.dart';

import '../src/suite_map.dart';

void main() {
  _IndexMapSuite().run();
}

final class _IndexMapSuite extends MapSuite {
  _IndexMapSuite() : super('IndexMap');

  @override
  Map<K, V> newEmptyMap<K, V>() {
    return IndexMap();
  }

  @override
  Map<K, V> newMapWith1kEntries<K, V>(Iterable<MapEntry<K, V>> items) {
    return IndexMap<K, V>.fromEntries(items);
  }

  @override
  Map<K, V> newMapWillInsert1kItemsLazy<K, V>() {
    return IndexMap<K, V>();
  }
}
