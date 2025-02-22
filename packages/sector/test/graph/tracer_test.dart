import '../prelude.dart';

void main() {
  test('chain', () {
    final a = TraceRecorder<int>();
    final b = TraceRecorder<int>();
    final c = a.chain(b);

    c.onVisit(1);
    check(a.events).containsInOrder([TraceEvent.onVisit(1)]);
    check(b.events).containsInOrder([TraceEvent.onVisit(1)]);

    c.clear();
    check(a.events).isEmpty();
    check(b.events).isEmpty();

    c.onSkip(2);
    check(a.events).containsInOrder([TraceEvent.onSkip(2)]);
    check(b.events).containsInOrder([TraceEvent.onSkip(2)]);
  });

  test('should be de-duplicatable', () {
    final a = TraceRecorder<int>();

    a.onVisit(1);
    a.onVisit(1);
    a.onSkip(2);
    a.onSkip(2);

    check(
      a.events.toSet(),
    ).containsInOrder([TraceEvent.onVisit(1), TraceEvent.onSkip(2)]);
  });

  group('events', () {
    test('should have a reasonable toString', () {
      final visit = TraceEvent.onVisit(1);
      final skip = TraceEvent.onSkip(2);

      check(visit.toString()).endsWith('.onVisit(1)');
      check(skip.toString()).endsWith('.onSkip(2)');
    });
  });
}
