import '_prelude.dart';

void main() {
  test('cardinal directions are north, east, south, west', () {
    // Ensure 'values' contains only cardinal directions.
    check(
      Direction.values.where((d) => d.isCardinal),
    ).deepEquals(Direction.cardinal);

    // Ensure 'cardinal' is exactly the four cardinal directions.
    check(Direction.cardinal).deepEquals([
      Direction.north,
      Direction.east,
      Direction.south,
      Direction.west,
    ]);
  });

  test('ordinal directions are northEast, southEast, southWest, northWest', () {
    // Ensure 'values' contains only ordinal directions.
    check(
      Direction.values.where((d) => d.isOrdinal),
    ).deepEquals(Direction.ordinal);

    // Ensure 'ordinal' is exactly the four ordinal directions.
    check(Direction.ordinal).deepEquals([
      Direction.northEast,
      Direction.southEast,
      Direction.southWest,
      Direction.northWest,
    ]);
  });

  group('aliases are as expected', () {
    ({
      Direction.up: Direction.north,
      Direction.upRight: Direction.northEast,
      Direction.right: Direction.east,
      Direction.downRight: Direction.southEast,
      Direction.down: Direction.south,
      Direction.downLeft: Direction.southWest,
      Direction.left: Direction.west,
      Direction.upLeft: Direction.northWest,
    }).forEach((alias, direction) {
      test('$alias is an alias for $direction', () {
        check(alias).equals(direction);
      });
    });
  });

  test('sorts directions in clock-wise order', () {
    for (var i = 0; i < 10; i++) {
      final directions = Direction.values.toList()..shuffle();
      directions.sort(Direction.byClockwise);
      check(directions).deepEquals([
        Direction.north,
        Direction.northEast,
        Direction.east,
        Direction.southEast,
        Direction.south,
        Direction.southWest,
        Direction.west,
        Direction.northWest,
      ]);
    }
  });

  test('sorts directions in counter-clock-wise order', () {
    for (var i = 0; i < 10; i++) {
      final directions = Direction.values.toList()..shuffle();
      directions.sort(Direction.byCounterClockwise);
      check(directions).deepEquals([
        Direction.north,
        Direction.northWest,
        Direction.west,
        Direction.southWest,
        Direction.south,
        Direction.southEast,
        Direction.east,
        Direction.northEast,
      ]);
    }
  });

  group('each value as expected', () {
    ({
      Direction.north: Pos(0, -1),
      Direction.northEast: Pos(1, -1),
      Direction.east: Pos(1, 0),
      Direction.southEast: Pos(1, 1),
      Direction.south: Pos(0, 1),
      Direction.southWest: Pos(-1, 1),
      Direction.west: Pos(-1, 0),
      Direction.northWest: Pos(-1, -1),
    }).forEach((direction, pos) {
      test('$direction is $pos', () {
        check(direction as Pos).equals(pos);
      });
    });
  });

  group('each opposite as expected', () {
    ({
      Direction.north: Direction.south,
      Direction.northEast: Direction.southWest,
      Direction.east: Direction.west,
      Direction.southEast: Direction.northWest,
      Direction.south: Direction.north,
      Direction.southWest: Direction.northEast,
      Direction.west: Direction.east,
      Direction.northWest: Direction.southEast,
    }).forEach((direction, opposite) {
      test('opposite of $direction is $opposite', () {
        check(direction.opposite).equals(opposite);
      });
    });
  });

  group('rotate90 guarantees a Direction', () {
    for (final direction in Direction.values) {
      test('rotating $direction by 90 degrees', () {
        check(Direction.values).contains(direction.rotate90());
      });
    }
  });

  group('rotate180 guarantees a Direction', () {
    for (final direction in Direction.values) {
      test('rotating $direction by 180 degrees', () {
        check(Direction.values).contains(direction.rotate180());
      });
    }
  });

  group('operator- guarantees a Direction', () {
    for (final direction in Direction.values) {
      test('negating $direction', () {
        check(Direction.values).contains(-direction);
      });
    }
  });
}
