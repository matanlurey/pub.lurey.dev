part of '../lodim.dart';

/// A direction in a 2D space.
///
/// This class represents a direction in a 2D space, with a fixed distance of 1
/// unit. The direction can be one of the four [cardinal] directions, or one of
/// four [ordinal] directions, or [all] eight values.
///
/// {@category Grids}
/// {@category Graphs}
extension type const Direction._(Pos _) implements Pos {
  /// A comparator that sorts directions in clockwise order.
  ///
  /// The order is [north], [northWest] ... [northEast].
  static const Comparator<Direction> byClockwise = _byClockwise;
  static int _byClockwise(Direction a, Direction b) {
    return a._clockwiseOrder.compareTo(b._clockwiseOrder);
  }

  /// A comparator that sorts directions in counter-clockwise order.
  ///
  /// The order is [north], [northEast] ... [northWest].
  static const Comparator<Direction> byCounterClockwise = _byCounterClockwise;
  static int _byCounterClockwise(Direction a, Direction b) {
    return a._counterClockwiseOrder.compareTo(b._counterClockwiseOrder);
  }

  /// Horizontal or vertical directions: [north], [east], [south], [west].
  ///
  /// This list is unmodifiable.
  static const cardinal = [
    north,
    east,
    south,
    west,
  ];

  /// Diagonal directions: [northEast], [southEast], [southWest], [northWest].
  ///
  /// This list is unmodifiable.
  static const ordinal = [
    northEast,
    southEast,
    southWest,
    northWest,
  ];

  /// All eight cardinal and ordinal directions, in clockwise order.
  ///
  /// This list is unmodifiable.
  @Deprecated('Use Direction.all instead')
  static const values = all;

  /// All eight cardinal and ordinal directions, in clockwise order.
  ///
  /// This list is unmodifiable.
  static const all = [
    north,
    northEast,
    east,
    southEast,
    south,
    southWest,
    west,
    northWest,
  ];

  /// Direction 'north', or [up], represented as `(0, -1)`.
  static const north = Pos(0, -1) as Direction;

  /// Alias for [north].
  static const up = north;

  /// Direction 'north-east', or [upRight], represented as `(1, -1)`.
  static const northEast = Pos(1, -1) as Direction;

  /// Alias for [northEast].
  static const upRight = northEast;

  /// Direction 'east', or [right], represented as `(1, 0)`.
  static const east = Pos(1, 0) as Direction;

  /// Alias for [east].
  static const right = east;

  /// Direction 'south-east', or [downRight] represented as `(1, 1)`.
  static const southEast = Pos(1, 1) as Direction;

  /// Alias for [southEast].
  static const downRight = southEast;

  /// Direction 'south', or [down], represented as `(0, 1)`.
  static const south = Pos(0, 1) as Direction;

  /// Alias for [south].
  static const down = south;

  /// Direction 'south-west', or [downLeft], represented as `(-1, 1)`.
  static const southWest = Pos(-1, 1) as Direction;

  /// Alias for [southWest].
  static const downLeft = southWest;

  /// Direction 'west', or [left], represented as `(-1, 0)`.
  static const west = Pos(-1, 0) as Direction;

  /// Alias for [west].
  static const left = west;

  /// Direction 'north-west', or [upLeft], represented as `(-1, -1)`.
  static const northWest = Pos(-1, -1) as Direction;

  /// Alias for [northWest].
  static const upLeft = northWest;

  @redeclare
  Direction rotate90([int steps = 1]) => _.rotate90(steps) as Direction;

  @redeclare
  Direction rotate180() => _.rotate180() as Direction;

  @redeclare
  Direction operator -() => -_ as Direction;

  /// The direction that is 180° opposite to this direction.
  ///
  /// ## Example
  ///
  /// ```dart
  /// print(Direction.north.opposite == Direction.south); // => true
  /// print(Direction.southEast.opposite == Direction.northWest); // => true
  /// ```
  Direction get opposite => -this;

  /// Whether this direction is a _cardinal_, or horizontal/vertical direction.
  bool get isCardinal => x == 0 || y == 0;

  /// Whether this direction is an _ordinal_, or diagonal direction.
  bool get isOrdinal => !isCardinal;

  int get _clockwiseOrder {
    return switch (this) {
      north => 0,
      northEast => 1,
      east => 2,
      southEast => 3,
      south => 4,
      southWest => 5,
      west => 6,
      _ => 7,
    };
  }

  int get _counterClockwiseOrder {
    return switch (this) {
      north => 0,
      northWest => 1,
      west => 2,
      southWest => 3,
      south => 4,
      southEast => 5,
      east => 6,
      _ => 7,
    };
  }
}
