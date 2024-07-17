import 'package:sector/sector.dart' show FlatQueue;
import '../src/suite_queue.dart';

void main() {
  _FlatQueueSuite().run();
}

final class _FlatQueueSuite extends QueueSuite<FlatQueue> {
  _FlatQueueSuite() : super('FlatQueue');

  @override
  FlatQueue newEmptyQueue() {
    return FlatQueue();
  }

  @override
  void add(FlatQueue queue, int element, double priority) {
    queue.add(element, priority);
  }

  @override
  int pop(FlatQueue queue) {
    return queue.removeFirst().$1;
  }

  @override
  int length(FlatQueue queue) {
    return queue.length;
  }
}
