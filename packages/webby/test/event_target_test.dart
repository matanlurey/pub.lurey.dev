import 'dart:async';

import 'package:webby/webby.dart';

import '_prelude.dart';

void main() {
  test('add/remove/dispatch', () async {
    final target = EventTarget();
    final fooEvent = Event('foo');

    scheduleMicrotask(() {
      target.dispatchEvent(fooEvent);
    });

    await check(target.on('foo')).withQueue.emits((e) {
      e.equals(fooEvent);
    });
  });
}
