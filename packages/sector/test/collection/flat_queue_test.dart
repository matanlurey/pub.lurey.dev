import 'dart:math';

import '../prelude.dart';

void main() {
  test('should be empty', () {
    final queue = FlatQueue();

    check(queue).has((p) => p.length, 'length').equals(0);
    check(queue).has((p) => p.isEmpty, 'isEmpty').isTrue();
    check(queue).has((p) => p.isNotEmpty, 'isNotEmpty').isFalse();
    check(queue)
        .has(
          (p) =>
              () => p.first,
          'first',
        )
        .throws<StateError>();
    check(queue)
        .has(
          (p) =>
              () => p.removeFirst(),
          'pop()',
        )
        .throws<StateError>();
  });

  test('should be non-empty', () {
    final queue = FlatQueue()..add(1, 1.0);

    check(queue).has((p) => p.length, 'length').equals(1);
    check(queue).has((p) => p.isEmpty, 'isEmpty').isFalse();
    check(queue).has((p) => p.isNotEmpty, 'isNotEmpty').isTrue();
    check(queue).has((p) => p.first, 'first').equals((1, 1.0));
    check(queue).has((p) => p.removeFirst(), 'pop()').equals((1, 1.0));
  });

  test('should result in an ascending order', () {
    final list = List.generate(5, (i) => (i + 1, (i + 1).toDouble()));
    list.shuffle(Random(1234));

    final queue = FlatQueue();
    for (final (value, priority) in list) {
      queue.add(value, priority);
    }

    check(queue).has((p) => p.removeFirst(), 'pop()').equals((1, 1.0));
    check(queue).has((p) => p.removeFirst(), 'pop()').equals((2, 2.0));
    check(queue).has((p) => p.removeFirst(), 'pop()').equals((3, 3.0));
    check(queue).has((p) => p.removeFirst(), 'pop()').equals((4, 4.0));
    check(queue).has((p) => p.removeFirst(), 'pop()').equals((5, 5.0));

    check(queue).has((p) => p.length, 'length').equals(0);
    check(queue).has((p) => p.isEmpty, 'isEmpty').isTrue();
    check(() => queue.first).throws<StateError>();

    queue.compact();
    check(queue).has((p) => p.length, 'length').equals(0);
    check(queue).has((p) => p.isEmpty, 'isEmpty').isTrue();

    queue.add(1, 1.0);
    check(queue).has((p) => p.length, 'length').equals(1);
    check(queue).has((p) => p.isEmpty, 'isEmpty').isFalse();
  });

  test('clear sets the length to 0', () {
    final queue = FlatQueue()..add(1, 1.0);

    check(queue).has((p) => p.length, 'length').equals(1);
    queue.clear();
    check(queue).has((p) => p.length, 'length').equals(0);
  });

  test('compact does not eliminate elements', () {
    final queue = FlatQueue()..add(1, 1.0);

    check(queue).has((p) => p.length, 'length').equals(1);
    queue.compact();
    check(queue).has((p) => p.length, 'length').equals(1);
  });

  test('should stress test', () {
    // Add 1000 numbers, 100 at a time, calling compact every 100.
    final numbers = List.generate(1000, (i) => (i + 1, (i + 1).toDouble()));
    numbers.shuffle(Random(1234));

    final queue = FlatQueue();
    for (final (value, priority) in numbers) {
      queue.add(value, priority);
      if (queue.length % 100 == 0) {
        queue.compact();
      }
    }

    check(queue).has((p) => p.length, 'length').equals(1000);

    // Now remove all 1000 numbers and ensure they are in order.
    final results = List.generate(1000, (_) => queue.removeFirst());
    numbers.sort((a, b) => a.$2.compareTo(b.$2));
    check(results).deepEquals(numbers);
  });

  test('should have a reasonable toString', () {
    final empty = FlatQueue().toString();
    check(empty).equals('FlatQueue ()');

    final queue = FlatQueue()..add(1, 1.0);
    final one = queue.toString();
    check(one).equals('FlatQueue ((1, 1.0) ... 1 elements)');
  });
}
