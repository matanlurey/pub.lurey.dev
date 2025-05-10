import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  test('cast', () {
    final numbers = ReadOnlyListView<num>([1, 2, 3]);
    final integers = numbers.cast<int>();
    check(integers).deepEquals([1, 2, 3]);
  });

  test('operator[]', () {
    final list = ReadOnlyListView([1, 2, 3]);
    check(list[0]).equals(1);
    check(list[1]).equals(2);
    check(list[2]).equals(3);
    check(() => list[3]).throws<RangeError>();
  });

  test('asMap', () {
    final list = ReadOnlyListView([1, 2, 3]);
    check(list.asMap()).deepEquals({0: 1, 1: 2, 2: 3});
  });

  test('getRange', () {
    final list = ReadOnlyListView([1, 2, 3]);
    final range = list.getRange(0, 2);
    check(range).deepEquals([1, 2]);
    check(() => list.getRange(0, 4)).throws<RangeError>();
  });

  test('indexOf', () {
    final list = ReadOnlyListView([1, 2, 3]);
    check(list.indexOf(2)).equals(1);
    check(list.indexOf(4)).equals(-1);
  });

  test('indexWhere', () {
    final list = ReadOnlyListView([1, 2, 3]);
    check(list.indexWhere((e) => e == 2)).equals(1);
    check(list.indexWhere((e) => e == 4)).equals(-1);
  });

  test('lastIndexOf', () {
    final list = ReadOnlyListView([1, 2, 3, 2]);
    check(list.lastIndexOf(2)).equals(3);
    check(list.lastIndexOf(4)).equals(-1);
  });

  test('lastIndexWhere', () {
    final list = ReadOnlyListView([1, 2, 3, 2]);
    check(list.lastIndexWhere((e) => e == 2)).equals(3);
    check(list.lastIndexWhere((e) => e == 4)).equals(-1);
  });

  test('reversed', () {
    final list = ReadOnlyListView([1, 2, 3]);
    final reversed = list.reversed;
    check(reversed).deepEquals([3, 2, 1]);
  });
  test('sublist', () {
    final list = ReadOnlyListView([1, 2, 3]);
    final sublist = list.sublist(1, 3);
    check(sublist).deepEquals([2, 3]);
    check(() => list.sublist(0, 4)).throws<RangeError>();
  });

  test('sublist', () {
    final list = ReadOnlyListView([1, 2, 3]);
    final sublist = list.sublist(1, 3);
    check(sublist).deepEquals([2, 3]);
    check(() => list.sublist(0, 4)).throws<RangeError>();
  });

  test('toList', () {
    final list = ReadOnlyListView([1, 2, 3]);
    final newList = list.toList();
    check(newList).deepEquals([1, 2, 3]);
  });

  test('asList', () {
    final list = ReadOnlyListView([1, 2, 3]);
    final newList = list.asList();
    check(newList).deepEquals([1, 2, 3]);
    check(() => newList.add(4)).throws<UnsupportedError>();
  });

  test('toString', () {
    final list = ReadOnlyListView([1, 2, 3]);
    check(list.toString()).equals('[1, 2, 3]');
  });
}
