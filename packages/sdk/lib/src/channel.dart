import 'package:meta/meta.dart';

/// Various channels available with releases of the Dart SDK.
@immutable
final class Channel {
  /// Tested and approved for production use.
  static const stable = Channel._('stable');

  /// Preview builds for the [stable] channel.
  ///
  /// It is recommended to test, but not release, apps and packages against
  /// [beta] to preview new features or test compatibility with future releases.
  ///
  /// Not suitable for production use.
  static const beta = Channel._('beta');

  /// Early access to new features, but might contain bugs.
  ///
  /// Not suitable for production use.
  static const dev = Channel._('dev');

  /// Latest, raw builds from the `main` branch of the Dart SDK repository.
  ///
  /// Suitable only for experimental development use, not for production.
  static const main = Channel._('main');

  /// All officially supported channels.
  static const supported = [stable, beta, dev, main];

  /// Returns a channel with the given [name].
  ///
  /// [name] is not required to be a [supported] channel name.
  factory Channel.unsupported(String name) {
    return Channel.tryFrom(name) ?? Channel._(name);
  }

  const Channel._(this.name);

  /// Name of the channel.
  final String name;

  /// Parses a channel from [name].
  ///
  /// If [name] is not a [supported] channel name, returns `null`.
  static Channel? tryFrom(String name) {
    for (final channel in Channel.supported) {
      if (channel.name == name) {
        return channel;
      }
    }
    return null;
  }

  /// Parses a channel from [name].
  ///
  /// The [name] must be a [supported] channel name.
  factory Channel.from(String name) {
    final channel = tryFrom(name);
    if (channel == null) {
      throw ArgumentError.value(name, 'name', 'Invalid channel name');
    }
    return channel;
  }

  /// Whether this channel is suitable for production use.
  bool get isStable => this == stable;

  /// Whether this channel is official (supported).
  bool get isSupported => supported.contains(this);

  @override
  bool operator ==(Object other) => other is Channel && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return isSupported ? 'Channel.$name' : 'Channel.unsupported($name)';
  }
}
