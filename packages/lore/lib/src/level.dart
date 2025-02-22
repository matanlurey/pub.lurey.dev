import 'package:lore/src/level_enabler.dart';
import 'package:meta/meta.dart';

/// Controls the verbosity of logging output by a logger.
///
/// Levels are ordered by their severity, with [Level.debug] being the least
/// severe and [Level.fatal] being the most severe. The default level is
/// typically [Level.status]; programs can interpret a level provided as a
/// configuration string by using [Level.tryParse] or [Level.parse].
@immutable
final class Level with LevelEnabler implements Comparable<Level> {
  /// A voluminous amount of information, useful for debugging purposes.
  static const debug = Level._(0, 'debug');

  /// Default logging level.
  static const status = Level._(1, 'status');

  /// The program is still able to operate.
  static const warning = Level._(2, 'warning');

  /// The program is unable to operate.
  static const error = Level._(3, 'error');

  /// The program is unable to operate and will be terminated immediately.
  static const fatal = Level._(4, 'fatal');

  /// All possible levels.
  static const values = [debug, status, warning, error, fatal];

  /// Parses a string representation of a level as it exactly matches [name].
  ///
  /// If the string is not a valid level, returns `null`.
  static Level? tryParse(String level) {
    for (final value in values) {
      if (value.name == level) {
        return value;
      }
    }
    return null;
  }

  /// Parses a string representation of a level.
  ///
  /// If the string is not a valid level, throws a [FormatException].
  static Level parse(String level) {
    final result = tryParse(level);
    if (result == null) {
      throw FormatException('Invalid level', level);
    }
    return result;
  }

  const Level._(@mustBeConst this.index, @mustBeConst this.name);

  /// Index of the level, for ordering purposes or binary serialization.
  final int index;

  /// Human readable name of the level, for debugging or printing purposes.
  final String name;

  @override
  bool isEnabled(Level level) => level >= this;

  @override
  Level get currentLevel => this;

  @override
  int compareTo(Level other) => index.compareTo(other.index);

  /// Returns whether this level is lower than the [other] level.
  bool operator <(Level other) => compareTo(other) < 0;

  /// Returns whether this level is lower than or equal to the [other] level.
  bool operator <=(Level other) => compareTo(other) <= 0;

  /// Returns whether this level is greater than the [other] level.
  bool operator >(Level other) => compareTo(other) > 0;

  /// Returns whether this level is greater than or equal to the [other] level.
  bool operator >=(Level other) => compareTo(other) >= 0;

  @override
  String toString() => 'Level.$name';
}
