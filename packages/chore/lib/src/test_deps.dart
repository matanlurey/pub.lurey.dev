import 'package:meta/meta.dart';

/// Dependencies required for testing.
@immutable
final class TestDependency {
  /// Requires installing the Chrome browser.
  static const chrome = TestDependency._('chrome');

  const TestDependency._(this.name);

  /// Name of the dependency.
  final String name;

  @override
  String toString() => 'TestDependency.$name';
}
