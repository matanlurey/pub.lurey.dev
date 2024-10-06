import 'dart:async';
import 'dart:io';

import 'package:mansion/mansion.dart';

void main() async {
  stdout.writeln('Which sub-program to execute?');
  stdout.writeln('1. Key Events');
  stdout.writeln('2. Mouse Events');
  stdout.writeln('3. Paste Events');
  stdout.writeln('4. Focus Events');
  stdout.writeln('5. Resize Events');

  try {
    stdin
      ..echoMode = false
      ..lineMode = false;

    switch (int.tryParse(String.fromCharCode(stdin.readByteSync()))) {
      case 1:
        await keyEvents();
      case 2:
        await mouseEvents();
      case 3:
        await pasteEvents();
      case 4:
        await focusEvents();
      default:
        stdout.writeln('Invalid.');
    }
  } finally {
    try {
      stdin
        ..echoMode = true
        ..lineMode = true;
    } on Object catch (_) {}
  }
}

Future<void> keyEvents() async {
  stdout.writeln('Press any key and then enter to see its key code.');
  stdout.writeln('Press CTRL-C to quit');
  stdout.writeln('Note that in this default mode not all keys are reported.');

  var running = true;
  late final StreamSubscription<void> sigint;
  sigint = ProcessSignal.sigint.watch().listen((event) {
    running = false;
  });

  final buffer = <List<int>>[];
  late final StreamSubscription<void> input;
  input = stdin.listen(buffer.add);

  while (running) {
    await _yield();
    if (buffer.isEmpty) {
      continue;
    }

    final events = buffer.toList();
    buffer.clear();

    for (final keys in events) {
      final event = Event.tryParse(keys);
      if (event != null) {
        stdout.writeln('$event');
      } else {
        stdout.writeln(
          'Codes: ${keys.map((key) => '0x${key.toRadixString(16)}').join(', ')}',
        );
      }
    }
  }

  await sigint.cancel();
  await input.cancel();
}

Future<void> mouseEvents() async {
  stdout.writeln('Move around the mouse and press on the terminal.');
  stdout.writeln('Press CTRL-C to quit');

  var running = true;
  late final StreamSubscription<void> sigint;
  sigint = ProcessSignal.sigint.watch().listen((event) {
    running = false;
  });

  final buffer = <List<int>>[];
  late final StreamSubscription<void> input;
  input = stdin.listen(buffer.add);

  try {
    stdout.writeln('Enabling mouse capture');
    stdout.writeAnsiAll(EnableMouseCapture.all);
    while (running) {
      await _yield();
      if (buffer.isEmpty) {
        continue;
      }

      final events = buffer.toList();
      buffer.clear();

      for (final keys in events) {
        final event = Event.tryParse(keys);
        if (event != null) {
          stdout.writeln('$event');
        } else {
          stdout.writeln(
            'Codes: ${keys.map((key) => '0x${key.toRadixString(16)}').join(', ')}',
          );
        }
      }
    }
  } finally {
    stdout.writeln('Disabling mouse capture');
    stdout.writeAnsiAll(DisableMouseCapture.all);

    await sigint.cancel();
    await input.cancel();
  }
}

Future<void> pasteEvents() async {
  stdout.writeln('Paste some text into the terminal');

  late final StreamSubscription<void> input;

  try {
    stdout.writeAnsi(CapturePaste.enable);
    final buffer = <List<int>>[];
    input = stdin.listen(buffer.add);

    while (true) {
      await _yield();
      if (buffer.isEmpty) {
        continue;
      }

      final events = buffer.toList();
      buffer.clear();
      for (final e in events) {
        final event = Event.tryParse(e);
        if (event is PasteEvent) {
          stdout.writeln('Pasted: ${event.text}');
          return;
        } else if (event != null) {
          stdout.writeln('Ignored: $event');
        } else {
          stdout.writeln(
            'Codes: ${e.map((key) => '0x${key.toRadixString(16)}').join(', ')}',
          );
        }
      }
    }
  } finally {
    stdout.writeAnsi(CapturePaste.disable);
    await input.cancel();
  }
}

Future<void> focusEvents() async {
  stdout.writeln('Switch focus between different windows');

  late final StreamSubscription<void> input;

  try {
    stdout.writeAnsi(CaptureFocus.enable);
    final buffer = <List<int>>[];
    input = stdin.listen(buffer.add);

    while (true) {
      await _yield();
      if (buffer.isEmpty) {
        continue;
      }

      final events = buffer.toList();
      buffer.clear();
      for (final e in events) {
        final event = Event.tryParse(e);
        if (event is FocusEvent && event == FocusEvent.gained) {
          stdout.writeln('Gained focus!');
          return;
        } else if (event != null) {
          stdout.writeln('Ignored: $event');
        } else {
          stdout.writeln(
            'Codes: ${e.map((key) => '0x${key.toRadixString(16)}').join(', ')}',
          );
        }
      }
    }
  } finally {
    stdout.writeAnsi(CaptureFocus.disable);
    await input.cancel();
  }
}

Future<void> _yield() => Future<void>.delayed(const Duration(milliseconds: 10));
