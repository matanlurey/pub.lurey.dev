import 'package:trove/trove.dart';

void main() {
  // Example usage of PlayingCard
  final card1 = PlayingCard(PlayingCardRank.ace, PlayingCardSuit.hearts);
  final card2 = PlayingCard(PlayingCardRank.two, PlayingCardSuit.spades);

  print(card1); // Output: Ace of Hearts
  print(card2); // Output: Two of Spades
}
