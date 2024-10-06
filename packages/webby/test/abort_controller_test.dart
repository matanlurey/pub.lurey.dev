import 'dart:async';
import 'dart:js_interop';

import 'package:webby/webby.dart';

import '_prelude.dart';

void main() {
  test('create and a controller and abort it', () async {
    final controller = AbortController();
    final reason = 'I said so'.toJS;
    check(controller.signal).has((a) => a.aborted, 'aborted').isFalse();

    // Abort the controller after a microtask.
    scheduleMicrotask(() {
      controller.abort(reason);
    });

    await check(controller.signal.onAbort).withQueue.emits();
    check(controller.signal).has((a) => a.aborted, 'aborted').isTrue();
    check(controller.signal).has((a) => a.reason, 'reason').equals(reason);
  });
}
