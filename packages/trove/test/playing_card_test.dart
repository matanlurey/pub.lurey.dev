import 'package:trove/src/playing_card.dart';

import '_prelude.dart';

void main() {
  group('PlayingCard', () {
    test('operator==', () {
      final a = PlayingCard(PlayingCardRank.ace, PlayingCardSuit.hearts);
      final b = PlayingCard(PlayingCardRank.ace, PlayingCardSuit.hearts);
      final c = PlayingCard(PlayingCardRank.two, PlayingCardSuit.hearts);

      check(a).equals(b);
      check(a).not((a) => a.equals(c));
    });

    test('hashCode', () {
      final a = PlayingCard(PlayingCardRank.ace, PlayingCardSuit.hearts);
      final b = PlayingCard(PlayingCardRank.ace, PlayingCardSuit.hearts);
      final c = PlayingCard(PlayingCardRank.two, PlayingCardSuit.hearts);

      check(a.hashCode).equals(b.hashCode);
      check(a.hashCode).not((a) => a.equals(c.hashCode));
    });

    test('toString', () {
      final a = PlayingCard(PlayingCardRank.ace, PlayingCardSuit.hearts);
      final b = PlayingCard(PlayingCardRank.two, PlayingCardSuit.spades);

      check(a.toString()).equals('Ace of Hearts');
      check(b.toString()).equals('Two of Spades');
    });
  });

  group('PlayingCardSuit', () {
    test('isRed', () {
      final hearts = PlayingCardSuit.hearts;
      final diamonds = PlayingCardSuit.diamonds;
      final clubs = PlayingCardSuit.clubs;
      final spades = PlayingCardSuit.spades;

      check(hearts.isRed).isTrue();
      check(diamonds.isRed).isTrue();
      check(clubs.isRed).isFalse();
      check(spades.isRed).isFalse();
    });

    test('isBlack', () {
      final hearts = PlayingCardSuit.hearts;
      final diamonds = PlayingCardSuit.diamonds;
      final clubs = PlayingCardSuit.clubs;
      final spades = PlayingCardSuit.spades;

      check(hearts.isBlack).isFalse();
      check(diamonds.isBlack).isFalse();
      check(clubs.isBlack).isTrue();
      check(spades.isBlack).isTrue();
    });
  });

  group('PlayingCardRank', () {
    test('isAce', () {
      check(PlayingCardRank.ace).has((c) => c.isAce, 'isAce').isTrue();
      check(PlayingCardRank.two).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.three).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.four).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.five).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.six).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.seven).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.eight).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.nine).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.ten).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.jack).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.queen).has((c) => c.isAce, 'isAce').isFalse();
      check(PlayingCardRank.king).has((c) => c.isAce, 'isAce').isFalse();
    });

    test('isFace', () {
      check(PlayingCardRank.ace).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.two).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.three).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.four).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.five).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.six).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.seven).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.eight).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.nine).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.ten).has((c) => c.isFace, 'isFace').isFalse();
      check(PlayingCardRank.jack).has((c) => c.isFace, 'isFace').isTrue();
      check(PlayingCardRank.queen).has((c) => c.isFace, 'isFace').isTrue();
      check(PlayingCardRank.king).has((c) => c.isFace, 'isFace').isTrue();
    });

    test('isNumber', () {
      check(PlayingCardRank.ace).has((c) => c.isNumber, 'isNumber').isFalse();
      check(PlayingCardRank.two).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.three).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.four).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.five).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.six).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.seven).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.eight).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.nine).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.ten).has((c) => c.isNumber, 'isNumber').isTrue();
      check(PlayingCardRank.jack).has((c) => c.isNumber, 'isNumber').isFalse();
      check(PlayingCardRank.queen).has((c) => c.isNumber, 'isNumber').isFalse();
      check(PlayingCardRank.king).has((c) => c.isNumber, 'isNumber').isFalse();
    });
  });
}
