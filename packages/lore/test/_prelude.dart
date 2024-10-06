import 'package:checks/checks.dart';
import 'package:lore/lore.dart';
import 'package:meta/meta.dart';

export 'package:checks/checks.dart';
export 'package:test/test.dart' show TestOn, group, setUp, tearDown, test;

extension AnySubject on Subject<Object?> {
  @useResult
  Subject<String> get toString$ {
    return has((o) => o.toString(), 'toString()');
  }
}

extension LevelSubject on Subject<Level> {
  @useResult
  Subject<Level> get currentLevel {
    return has((l) => l.currentLevel, 'currentLevel');
  }

  @useResult
  Subject<bool> isEnabled(Level level) {
    return has((l) => l.isEnabled(level), 'isEnabled');
  }

  @useResult
  Subject<String> get name {
    return has((l) => l.name, 'name');
  }

  @useResult
  Subject<bool> isLessThan(Level other) {
    return has((l) => l < other, '<');
  }

  @useResult
  Subject<bool> isLessOrEqual(Level other) {
    return has((l) => l <= other, '<=');
  }

  @useResult
  Subject<bool> isGreaterThan(Level other) {
    return has((l) => l > other, '>');
  }

  @useResult
  Subject<bool> isGreaterOrEqual(Level other) {
    return has((l) => l >= other, '>=');
  }
}
