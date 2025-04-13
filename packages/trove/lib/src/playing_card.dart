import 'package:meta/meta.dart';
import 'package:quirk/quirk.dart';

/// A standard playing card with a [rank] and [suit].
@immutable
final class PlayingCard {
  /// Creates a playing card with the given [rank] and [suit].
  const PlayingCard(this.rank, this.suit);

  /// The rank of the card.
  final PlayingCardRank rank;

  /// The suit of the card.
  final PlayingCardSuit suit;

  @override
  bool operator ==(Object other) {
    return other is PlayingCard && other.rank == rank && other.suit == suit;
  }

  @override
  int get hashCode => Object.hash(rank, suit);

  @override
  String toString() {
    return '${rank.name.capitalize()} of ${suit.name.capitalize()}';
  }
}

/// Suits for a standard playing card.
enum PlayingCardSuit {
  /// Suit of hearts.
  hearts,

  /// Suit of diamonds.
  diamonds,

  /// Suit of clubs.
  clubs,

  /// Suit of spades.
  spades;

  /// Whether the suit is red.
  bool get isRed => index < 2;

  /// Whether the suit is black.
  bool get isBlack => index >= 2;
}

/// Ranks for a standard playing card.
enum PlayingCardRank {
  /// Ace.
  ace,

  /// Two.
  two,

  /// Three.
  three,

  /// Four.
  four,

  /// Five.
  five,

  /// Six.
  six,

  /// Seven.
  seven,

  /// Eight.
  eight,

  /// Nine.
  nine,

  /// Ten.
  ten,

  /// Jack.
  jack,

  /// Queen.
  queen,

  /// King.
  king;

  /// Whether the rank is an [ace].
  bool get isAce => this == PlayingCardRank.ace;

  /// Whether the rank is considered a "face" card.
  bool get isFace => index >= PlayingCardRank.jack.index;

  /// Whether the rank is considered a "number" card.
  bool get isNumber {
    return index < PlayingCardRank.jack.index && !isAce;
  }
}
