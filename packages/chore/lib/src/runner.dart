import 'dart:async';

import 'package:chore/src/context.dart';

/// Runs a [task] with the given [context].
FutureOr<T> run<T>(
  FutureOr<T> Function(Context) task, {
  Context? context,
}) async {
  final completer = Completer<T>();
  final using = context ?? Context();
  late final StreamSubscription<void> onTerm;
  unawaited(
    runZonedGuarded(
      () async {
        onTerm = using.onDone.listen((_) {
          throw ToolExit();
        });
        final result = await task(using);
        completer.complete(result);
      },
      (error, stack) {
        if (completer.isCompleted) {
          return;
        }
        if (error is ToolExit) {
          completer.complete();
          return;
        }
        completer.completeError(error, stack);
      },
    ),
  );
  try {
    return await completer.future;
  } finally {
    await using.cleanup();
    await onTerm.cancel();
  }
}
