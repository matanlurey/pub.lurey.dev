import 'package:lore/src/level.dart';

/// Determines whether a given [Level] is considered enabled or not.
abstract mixin class LevelEnabler {
  /// Returns `true` if the given [level] is enabled.
  bool isEnabled(Level level);

  /// Returns the lowest enabled logging level.
  ///
  /// The default implementation tries [isEnabled] with each level in ascending
  /// order, starting from [Level.debug], and returns the first level for which
  /// [isEnabled] returns `true`. Implementations may override this method to
  /// provide a more efficient implementation.
  Level get currentLevel {
    for (final level in Level.values) {
      if (isEnabled(level)) {
        return level;
      }
    }
    throw StateError('No enabled logging level found');
  }
}
