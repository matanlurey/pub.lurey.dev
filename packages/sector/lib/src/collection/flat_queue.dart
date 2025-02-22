part of '../collection.dart';

/// A very fast and tiny binary heap priority queue that stores `(int, double`).
///
/// Similar to [`HeapPriorityQueue<(int, double)`][HeapPriorityQueue] but stores
/// the queue as two flat lists, one for the items (32-bit integers) and their
/// priority values (32-bit floats) respectively, and does not perform list
/// compaction after removing elements unless [compact] is called manually.
///
/// [HeapPriorityQueue]: https://pub.dev/documentation/collection/latest/collection/HeapPriorityQueue-class.html
///
/// ## Memory Allocation
///
/// In order to avoid thrashing spending main-thread time on performing list
/// compaction, the queue does not compact itself after removing elements,
/// retaining the (relatively cheap) `int` and `double` slots for future use.
/// This means that on long-running algorithms, the queue may grow in size
/// indefinitely, potentially causing memory issues, and should be discarded
/// (to let the native memory be garbage collected) when no longer needed.
///
/// ```dart
/// // Add 100 elements to a queue.
/// final queue = FlatQueue();
/// for (var i = 0; i < 100; i++) {
///   queue.add(i, i.toDouble());
/// }
///
/// // Clear the queue, but the memory is still allocated.
/// queue.clear();
/// print(queue.length); // 0
/// print(queue.capacity); // 100
/// ```
///
/// To manually free up memory without discarding, you can call [compact]:
///
/// ```dart
/// final queue = FlatQueue();
/// for (var i = 0; i < 100; i++) {
///   queue.add(i, i.toDouble());
/// }
///
/// queue.clear();
/// queue.compact();
/// print(queue.capacity); // 0
/// ```
///
/// ## Performance
///
/// The performance of the queue is predictable for a binary heap:
///
/// - `length`: `O(1)`
/// - `peek`: `O(1)`
/// - `pop`: `O(log n)`
/// - `add`: `O(log n)`
///
/// When compared to [`HeapPriorityQueue<(int, double)`][HeapPriorityQueue],
/// it's approximately:
///
/// - **~2x faster** to add elements;
/// - **~8x faster** when removing elements.
///
/// That is a significant speed up if you can deal with the constraints of this
/// queue.
///
/// {@category Collections}
final class FlatQueue {
  /// Creates an empty minimum priority queue.
  ///
  /// May optionally specify an [initialCapacity] and [growthRate]. Setting
  /// an [initialCapacity] can reduce the number of memory allocations needed
  /// when adding elements to the queue, and [growthRate] can be used to
  /// control how much the queue grows when it runs out of capacity, which
  /// additionally can reduce the number of memory allocations needed. For
  /// tuning algorithms, it's recommended to set [initialCapacity] to the
  /// expected number of elements in the queue, and [growthRate] to a value
  /// greater than 1.0 (which is the default).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final queue = FlatQueue(initialCapacity: 100, growthRate: 1.5);
  /// ```
  FlatQueue({int? initialCapacity, double? growthRate})
    : _ids = Uint32List(initialCapacity ?? 16),
      _priorities = Float32List(initialCapacity ?? 16),
      _growthRate = growthRate ?? 1.0;

  Uint32List _ids;
  Float32List _priorities;
  final double _growthRate;

  /// Whether the queue is empty.
  bool get isEmpty => _length == 0;

  /// Whether the queue is not empty.
  bool get isNotEmpty => _length != 0;

  /// The length of the queue.
  int get length => _length;
  var _length = 0;

  /// Clears the queue.
  void clear() {
    _length = 0;
  }

  /// Compact the queue to remove any slots that are no longer used.
  ///
  /// The queue, using [capacity] slots, is reduced to [length] slots.
  void compact() {
    if (_length == 0) {
      _ids = Uint32List(0);
      _priorities = Float32List(0);
    } else {
      _ids = _ids.sublist(0, _length);
      _priorities = _priorities.sublist(0, _length);
    }
  }

  /// How much capacity the queue is using, regardless of reported [length].
  ///
  /// Use [compact] to remove any unused slots.
  int get capacity => _ids.length;

  /// Returns the smallest element in the queue, and its priority.
  ///
  /// The content of the queue is not changed.
  ///
  /// The queue must not be empty.
  (int, double) get first {
    if (isEmpty) {
      throw StateError('Cannot peek at an empty priority queue');
    }
    return (_ids.first, _priorities.first);
  }

  /// Removes and returns the smallest element in the queue, and its priority.
  ///
  /// The queue must not be empty.
  (int, double) removeFirst() {
    final top = first;
    _length--;

    if (_length > 0) {
      final id = _ids.first = _ids[_length];
      final priority = _priorities.first = _priorities[_length];
      final halfLength = _length ~/ 2;

      var pos = 0;
      while (pos < halfLength) {
        var left = (pos << 1) + 1;
        final right = left + 1;
        var minId = _ids[left];
        var minPriority = _priorities[left];
        final rightPriority = _priorities[right];

        if (right < _length && rightPriority < minPriority) {
          left = right;
          minId = _ids[right];
          minPriority = rightPriority;
        }
        if (minPriority >= priority) {
          break;
        }

        _ids[pos] = minId;
        _priorities[pos] = minPriority;
        pos = left;
      }

      _ids[pos] = id;
      _priorities[pos] = priority;
    }

    return top;
  }

  /// Adds an [element] with a [priority] to the queue.
  ///
  /// The [priority] must be a finite number.
  ///
  /// The element is added to the queue in `O(log n)` time.
  void add(int element, double priority) {
    var pos = _length++;
    while (pos > 0) {
      final parent = (pos - 1) >> 1;
      if (priority >= _priorities[parent]) {
        break;
      }
      _set(_ids[parent], _priorities[parent], index: pos);
      pos = parent;
    }
    _set(element, priority, index: pos);
  }

  void _set(int a, double b, {required int index}) {
    if (index == _ids.length) {
      final int newLength;
      if (capacity == 0) {
        newLength = 16;
      } else {
        newLength = (capacity * _growthRate).ceil() + capacity;
      }
      _ids = Uint32List(newLength)..setAll(0, _ids);
      _priorities = Float32List(newLength)..setAll(0, _priorities);
    }
    _ids[index] = a;
    _priorities[index] = b;
  }

  @override
  String toString() {
    return isEmpty ? 'FlatQueue ()' : 'FlatQueue ($first ... $length elements)';
  }
}
