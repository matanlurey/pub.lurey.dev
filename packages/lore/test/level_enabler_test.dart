import 'package:lore/lore.dart';

import '_prelude.dart';

void main() {
  test('returns currentLevel', () {
    final enabler = _TestLevelEnabler((level) => level >= Level.warning);
    check(
      enabler,
    ).has((l) => l.currentLevel, 'currentLevel').equals(Level.warning);
  });

  test('throws if no level is enabled', () {
    final enabler = _TestLevelEnabler((level) => false);
    check(enabler)
        .has((l) => () => l.currentLevel, 'currentLevel')
        .throws<StateError>()
        .has((e) => e.message, 'message')
        .contains('No enabled logging level found');
  });
}

final class _TestLevelEnabler with LevelEnabler {
  const _TestLevelEnabler(this._isEnabled);
  final bool Function(Level) _isEnabled;

  @override
  bool isEnabled(Level level) => _isEnabled(level);
}
