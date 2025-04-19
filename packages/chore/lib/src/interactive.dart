import 'dart:async';

import 'package:chore/src/environment.dart';
import 'package:mansion/mansion.dart';
import 'package:proc/proc.dart';

/// A wrapper that starts an interactive command [run].
///
/// The user has the option of:
/// - Pressing `q` to quit;
/// - Pressing `r` to rerun the command;
///
/// The future completes when the user quits or CTRL+C is pressed.
Future<void> startInteractive(
  Future<void> Function() run, {
  required Environment environment,
}) async {
  final stdin = environment.stdin;
  final lineMode = stdin.lineMode;
  StreamSubscription<void>? onSigint;
  StreamSubscription<void>? onStdin;
  try {
    stdin.lineMode = false;

    // Wait for the user to press CTRL+C or `q` to quit.
    final completer = Completer<void>();
    void terminate() {
      if (completer.isCompleted) {
        return;
      }
      completer.complete();
    }

    // CTRL+C handler.
    onSigint = environment.processHost.watch(ProcessSignal.sigint).listen((_) {
      terminate();
    });

    // User input handler.
    onStdin = stdin.listen((input) async {
      switch (Event.tryParse(input)) {
        case KeyEvent(key: CharKey(character: 'r')):
          await run();
        case KeyEvent(key: CharKey(character: 'q')):
          terminate();
        default:
      }
    });

    // Run the command.
    await run();

    // Wait.
    await completer.future;
  } finally {
    stdin.lineMode = lineMode;
    await onSigint?.cancel();
    await onStdin?.cancel();
  }
}
