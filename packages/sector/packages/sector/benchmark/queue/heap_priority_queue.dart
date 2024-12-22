import 'package:collection/collection.dart' show HeapPriorityQueue;
import '../src/suite_queue.dart';

void main() {
  _HeapPriorityQueueSuite().run();
}

typedef _Queue = HeapPriorityQueue<(int, double)>;

final class _HeapPriorityQueueSuite extends QueueSuite<_Queue> {
  _HeapPriorityQueueSuite() : super('HeapPriorityQueue');

  static int _compare((int, double) a, (int, double) b) {
    return a.$2.compareTo(b.$2);
  }

  @override
  _Queue newEmptyQueue() {
    return HeapPriorityQueue(_compare);
  }

  @override
  void add(_Queue queue, int element, double priority) {
    queue.add((element, priority));
  }

  @override
  int pop(_Queue queue) {
    return queue.removeFirst().$1;
  }

  @override
  int length(_Queue queue) {
    return queue.length;
  }
}
