import 'package:chaos/chaos.dart';
import 'package:omen/omen.dart';

import '_prelude.dart';

void main() {
  test('const dice', () {
    check(const Dice(5)).equals(Dice.from(5));
  });

  test('cannot have 0 sides', () {
    check(() => Dice.from(0)).throws<ArgumentError>();
  });

  test('cannot have negative sides', () {
    check(() => Dice.from(-1)).throws<ArgumentError>();
  });

  test('implements == and hashCode', () {
    final d6a = Dice.from(6);
    final d6b = Dice.from(6);
    final d8a = Dice.from(8);
    final d8b = Dice.from(8);

    check(d6a).equals(d6b);
    check(d8a).equals(d8b);
    check(d6a).not((d) => d.equals(d8a));
    check(d6a).not((d) => d.equals(d8b));

    check(d6a.hashCode).equals(d6b.hashCode);
    check(d8a.hashCode).equals(d8b.hashCode);
    check(d6a.hashCode).not((d) => d.equals(d8a.hashCode));
  });

  test('sample', () {
    final random = SequenceRandom.uniform(6);
    final d6 = Dice.from(6);

    check(d6.sample(random)).equals(1);
    check(d6.sample(random)).equals(2);
    check(d6.sample(random)).equals(3);
    check(d6.sample(random)).equals(4);
    check(d6.sample(random)).equals(5);
    check(d6.sample(random)).equals(6);
  });

  test('toString', () {
    final d6 = Dice.from(6);
    final d8 = Dice.from(8);

    check(d6.toString()).equals('Dice(6)');
    check(d8.toString()).equals('Dice(8)');
  });
}
