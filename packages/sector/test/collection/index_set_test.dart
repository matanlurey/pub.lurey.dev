import 'package:meta/meta.dart';

import '../prelude.dart';

void main() {
  test('should create an IndexSet with a stable iteration order', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    check(set).contains('a');
    check(set).contains('b');
    check(set).contains('c');
    check(set).deepEquals(['a', 'b', 'c']);
  });

  test('should create a set from an iterable', () {
    final set = IndexSet<String>.from(['a', 'b', 'c']);
    check(set).deepEquals(['a', 'b', 'c']);
  });

  test('should not add, nor re-order, when an element exists', () {
    final set = IndexSet<String>();
    check(set.add('a')).isTrue();
    check(set.add('b')).isTrue();
    check(set.add('a')).isFalse();

    check(set).deepEquals(['a', 'b']);
  });

  test('should provide [] access to elements', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    check(set[0]).equals('a');
    check(set[1]).equals('b');
    check(set[2]).equals('c');
  });

  test('should be able to set elements with []=', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    set[0] = 'x';
    set[1] = 'y';
    set[2] = 'z';

    check(set).deepEquals(['x', 'y', 'z']);
  });

  test('should clear all elements', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    set.clear();
    check(set).isEmpty();
  });

  test('should lookup elements by object', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    check(set.lookup('a')).equals('a');
    check(set.lookup('b')).equals('b');
    check(set.lookup('c')).equals('c');
    check(set.lookup('d')).isNull();
  });

  test('should create a new set from toSet', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    final newSet = set.toSet();
    check(newSet).not((p) => p.identicalTo(set));
    check(newSet).deepEquals(['a', 'b', 'c']);
  });

  test('should remove elements by swapping with the last element', () {
    final set = IndexSet<String>();
    set.add('a');
    set.add('b');
    set.add('c');

    check(set.remove('b')).isTrue();
    check(set).deepEquals(['a', 'c']);

    check(set.remove('a')).isTrue();
    check(set).deepEquals(['c']);

    check(set.remove('c')).isTrue();
    check(set).isEmpty();
  });

  test('iterable sanity test', () {
    final set = IndexSet<String>();
    check(set).isEmpty();

    set.add('a');
    check(set).isNotEmpty();
    check(set.single).equals('a');
    check(set.elementAt(0)).equals('a');

    set.add('b');
    set.add('c');

    check(set.followedBy(['d'])).deepEquals(['a', 'b', 'c', 'd']);
    check(set.map((e) => e.toUpperCase())).deepEquals(['A', 'B', 'C']);
    check(set.where((e) => e != 'b')).deepEquals(['a', 'c']);
    check(set.whereType<int>()).isEmpty();
    check(set.expand((e) => [e, e])).deepEquals(['a', 'a', 'b', 'b', 'c', 'c']);

    final forEach = <String>[];
    set.forEach(forEach.add);
    check(forEach).deepEquals(['a', 'b', 'c']);

    check(set.reduce((a, b) => a + b)).equals('abc');
    check(set.fold('x', (a, b) => a + b)).equals('xabc');
    check(set.every((e) => e.length == 1)).isTrue();
    check(set.join()).equals('abc');
    check(set.any((e) => e == 'b')).isTrue();
    check(set.first).equals('a');
    check(set.last).equals('c');
    check(set.toList()).deepEquals(['a', 'b', 'c']);
    check(set.toSet()).deepEquals({'a', 'b', 'c'});
    check(set.take(2)).deepEquals(['a', 'b']);
    check(set.skip(1)).deepEquals(['b', 'c']);
    check(set.takeWhile((e) => e != 'c')).deepEquals(['a', 'b']);
    check(set.skipWhile((e) => e != 'b')).deepEquals(['b', 'c']);
    check(set.firstWhere((e) => e == 'b')).equals('b');
    check(set.lastWhere((e) => e == 'b')).equals('b');
    check(set.singleWhere((e) => e == 'b')).equals('b');
  });

  test('supports identity equality', () {
    final set = IndexSet<_BadHash>.identity();

    final a = _BadHash();
    final b = _BadHash();
    final c = _BadHash();

    set.add(a);
    set.add(b);
    set.add(c);

    check(set).deepEquals([a, b, c]);

    set.remove(b);
    check(set).deepEquals([a, c]);

    final copy = set.toSet();
    check(copy).deepEquals([a, c]);

    final alt = IndexSet<_BadHash>(
      equals: identical,
      hashCode: identityHashCode,
    );

    alt.add(a);
    alt.add(b);

    check(alt).deepEquals([a, b]);
  });

  test('supports custom equality', () {
    final set = IndexSet<String>(
      equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
      hashCode: (e) => e.toLowerCase().hashCode,
    );

    set.add('a');
    set.add('A');
    set.add('b');
    check(set).deepEquals(['a', 'b']);

    final copy = set.toSet();
    copy.add('B');
    check(copy).deepEquals(['a', 'b']);
  });
}

@immutable
final class _BadHash {
  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is _BadHash;
}
