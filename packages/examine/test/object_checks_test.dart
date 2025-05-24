import 'package:checks/checks.dart';
import 'package:examine/examine.dart';
import 'package:test/test.dart';

void main() {
  group('hasHashCode', () {
    test('should check hashCode', () {
      final aMinute = Duration(minutes: 1);
      final bMinute = Duration(minutes: 1);
      check(aMinute).hasHashCode.equals(bMinute.hashCode);
    });
  });

  group('hasToString', () {
    test('should check toString', () {
      final aMinute = Duration(minutes: 1);
      final bMinute = Duration(minutes: 1);
      check(aMinute).hasToString.equals(bMinute.toString());
    });
  });

  group('isEquivalentTo', () {
    test('should check equality and hashCode', () {
      final aMinute = Duration(minutes: 1);
      final bMinute = Duration(minutes: 1);
      check(aMinute).isEquivalentTo(bMinute);
    });

    test('should fail if not equal', () {
      final aMinute = Duration(minutes: 1);
      final bMinute = Duration(minutes: 2);
      check(aMinute).not((c) => c.isEquivalentTo(bMinute));
    });

    test('should fail if hashCode not equal', () {
      final aMinute = Duration(minutes: 1);
      final bMinute = Duration(minutes: 2);
      check(aMinute).not((c) => c.isEquivalentTo(bMinute));
    });
  });
}
