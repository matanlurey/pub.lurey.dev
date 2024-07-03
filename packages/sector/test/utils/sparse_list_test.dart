import 'dart:collection';

import 'package:sector/src/utils/sparse_list.dart';

import '../_prelude.dart';

void main() {
  test('filled can return an empty list', () {
    final list = SparseList.filled(0, fill: ' ');
    check(list.toDenseList()).deepEquals([]);
  });

  test('filled can return a list with a single element', () {
    final list = SparseList.filled(1, fill: ' ');
    check(list.toDenseList()).deepEquals([' ']);
  });

  test('filled can return a list with multiple elements', () {
    final list = SparseList.filled(3, fill: ' ');
    check(list.toDenseList()).deepEquals([' ', ' ', ' ']);
  });

  test('from can return an empty list', () {
    final list = SparseList.from([], fill: ' ');
    check(list.toDenseList()).deepEquals([]);
  });

  test('from can return a list with a single element', () {
    final list = SparseList.from(['a'], fill: ' ');
    check(list.toDenseList()).deepEquals(['a']);
  });

  test('from can return a list with multiple elements', () {
    final list = SparseList.from(['a', 'b', 'c'], fill: ' ');
    check(list.toDenseList()).deepEquals(['a', 'b', 'c']);
  });

  test('from can return a list with multiple elements and gaps', () {
    final list = SparseList.from(['a', ' ', 'c'], fill: ' ');
    check(list.toDenseList()).deepEquals(['a', ' ', 'c']);
  });

  test('view should return a list from a pre-filled SplayTreeMap', () {
    final tree = SplayTreeMap<int, String>.from({0: 'a', 2: 'b'});
    final view = SparseList.view(tree, fill: ' ', length: 3);
    check(view.toDenseList()).deepEquals(['a', ' ', 'b']);
  });

  test('should insert elements into an empty list', () {
    final list = SparseList.filled(0, fill: ' ');
    list.insertAll(0, ['a', 'b', 'c']);
    check(list.toDenseList()).deepEquals(['a', 'b', 'c']);
  });

  test('should insert elements into a list with elements', () {
    final list = SparseList.from(['a', 'd'], fill: ' ');
    list.insertAll(1, ['b', 'c']);
    check(list.toDenseList()).deepEquals(['a', 'b', 'c', 'd']);
  });

  test('should insert elements into a list with gaps', () {
    final list = SparseList.from(['a', ' ', 'd'], fill: ' ');
    list.insertAll(1, ['b', 'c']);
    check(list.length).equals(5);
    check(list.toDenseList()).deepEquals(['a', 'b', 'c', ' ', 'd']);
  });

  test('should remove elements from a list with elements', () {
    final list = SparseList.from(['a', 'b', 'c', 'd'], fill: ' ');
    list.removeRange(1, 3);
    check(list.toDenseList()).deepEquals(['a', 'd']);
  });

  test('should remove elements from a list with gaps', () {
    final list = SparseList.from(['a', ' ', 'b', 'c', 'd'], fill: ' ');
    list.removeRange(1, 4);
    check(list.toDenseList()).deepEquals(['a', 'd']);
  });

  test('should remove elements from a list with gaps and fill', () {
    final list = SparseList.from(['a', ' ', 'b', 'c', 'd'], fill: ' ');
    list.removeRange(1, 4);
    check(list.toDenseList()).deepEquals(['a', 'd']);
  });

  test('should remove elements from a list with gaps and fill', () {
    final list = SparseList.from(['a', ' ', 'b', 'c', 'd'], fill: ' ');
    list.removeRange(1, 4);
    check(list.toDenseList()).deepEquals(['a', 'd']);
  });

  test('should remove elements from a list with gaps and fill', () {
    final list = SparseList.from(['a', ' ', 'b', 'c', 'd'], fill: ' ');
    list.removeRange(1, 4);
    check(list.toDenseList()).deepEquals(['a', 'd']);
  });

  test('inserting to the start on an existing list should work', () {
    final list = SparseList.from(['b', 'c'], fill: ' ');
    list.insertAll(0, ['a']);
    check(list.toDenseList()).deepEquals(['a', 'b', 'c']);
  });

  test('operator[]= replacing with a fill removes it from the memory', () {
    final list = SparseList.from(['a', 'b', 'c'], fill: ' ');
    list[1] = ' ';
    check(list.toSparseMap()).deepEquals({0: 'a', 2: 'c'});
  });

  test('contains an empty space', () {
    final list = SparseList.from(['a', ' ', 'c'], fill: ' ');
    check(list.contains(' ')).isTrue();
  });

  test('does not contain an empty space', () {
    final list = SparseList.from(['a', 'b', 'c'], fill: ' ');
    check(list.contains(' ')).isFalse();
  });

  test('SpaseList.view cannot have a key >= length', () {
    final tree = SplayTreeMap<int, String>.from({0: 'a', 2: 'b'});
    check(
      () => SparseList.view(tree, fill: ' ', length: 2),
    ).throws<ArgumentError>();
  });
}
