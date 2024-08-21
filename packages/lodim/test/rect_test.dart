import '_prelude.dart';

void main() {
  test('should create from LTRB', () {
    final rect = Rect.fromLTRB(10, 20, 30, 40);
    check(rect.left).equals(10);
    check(rect.top).equals(20);
    check(rect.right).equals(30);
    check(rect.bottom).equals(40);
  });

  test('should create from LTWH', () {
    final rect = Rect.fromLTWH(10, 20, 20, 20);
    check(rect.left).equals(10);
    check(rect.top).equals(20);
    check(rect.right).equals(30);
    check(rect.bottom).equals(40);
  });

  test('should create from TLBR', () {
    final rect = Rect.fromTLBR(Pos(10, 20), Pos(30, 40));
    check(rect.left).equals(10);
    check(rect.top).equals(20);
    check(rect.right).equals(30);
    check(rect.bottom).equals(40);
  });

  test('should create from WH with default offset', () {
    final rect = Rect.fromWH(20, 20);
    check(rect.left).equals(0);
    check(rect.top).equals(0);
    check(rect.right).equals(20);
    check(rect.bottom).equals(20);
  });

  test('should create from WH with offset', () {
    final rect = Rect.fromWH(20, 20, offset: Pos(10, 20));
    check(rect.left).equals(10);
    check(rect.top).equals(20);
    check(rect.right).equals(30);
    check(rect.bottom).equals(40);
  });

  test('should enclose over two positions', () {
    final a = Pos(10, 20);
    final b = Pos(30, 40);
    final rect = Rect.encloses(a, b);
    check(rect.left).equals(10);
    check(rect.top).equals(20);
    check(rect.right).equals(30);
    check(rect.bottom).equals(40);
  });

  test('should sort byArea', () {
    final rects = [
      Rect.fromLTWH(0, 0, 10, 10),
      Rect.fromLTWH(0, 0, 20, 20),
      Rect.fromLTWH(0, 0, 5, 5),
    ];
    rects.sort(Rect.byArea);
    check(rects).deepEquals([
      Rect.fromLTWH(0, 0, 5, 5),
      Rect.fromLTWH(0, 0, 10, 10),
      Rect.fromLTWH(0, 0, 20, 20),
    ]);
  });

  test('zero is all 0s', () {
    check(Rect.zero).equals(Rect.fromLTWH(0, 0, 0, 0));
  });

  test('topLeft', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.topLeft).equals(Pos(10, 20));
  });

  test('topRight', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.topRight).equals(Pos(40, 20));
  });

  test('bottomLeft', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.bottomLeft).equals(Pos(10, 60));
  });

  test('bottomRight', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.bottomRight).equals(Pos(40, 60));
  });

  test('width', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.width).equals(30);
  });

  test('height', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.height).equals(40);
  });

  test('isEmpty', () {
    final rect = Rect.fromLTWH(10, 20, 0, 0);
    check(rect.isEmpty).isTrue();
  });

  test('isNotEmpty', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.isNotEmpty).isTrue();
  });

  test('area', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.area).equals(1200);
  });

  test('shortestSide', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.shortestSide).equals(30);
  });

  test('longestSide', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.longestSide).equals(40);
  });

  group('center', () {
    test('even width and height returns four points', () {
      // # #
      // # #
      final rect = Rect.fromLTWH(0, 0, 2, 2);
      check(rect.center).deepEquals([
        Pos(1, 1),
        Pos(2, 1),
        Pos(1, 2),
        Pos(2, 2),
      ]);
    });

    test('even width and odd height returns two points', () {
      // # #
      // # #
      // # #
      final rect = Rect.fromLTWH(0, 0, 3, 2);
      check(rect.center).deepEquals([
        Pos(1, 1),
        Pos(1, 2),
      ]);
    });

    test('odd width and even height returns two points', () {
      // # # #
      // # # #
      final rect = Rect.fromLTWH(0, 0, 2, 3);
      check(rect.center).deepEquals([
        Pos(1, 1),
        Pos(2, 1),
      ]);
    });

    test('odd width and height returns a single point', () {
      // # # #
      // # # #
      // # # #
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.center).deepEquals([
        Pos(1, 1),
      ]);
    });

    test('empty rect returns an empty list', () {
      final rect = Rect.fromLTWH(10, 20, 0, 0);
      check(rect.center).deepEquals([]);
    });
  });

  group('edges', () {
    test('returns all edges T -> R, R -> B, B -> L, L -> T', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.edges).deepEquals([
        Pos(0, 0),
        Pos(1, 0),
        Pos(2, 0),
        Pos(2, 1),
        Pos(2, 2),
        Pos(1, 2),
        Pos(0, 2),
        Pos(0, 1),
      ]);
    });

    test('returns a single edge for an 1x1 rect', () {
      final rect = Rect.fromLTWH(0, 0, 1, 1);
      check(rect.edges).deepEquals([Pos(0, 0)]);
    });

    test('returns no edges for an empty rect', () {
      final rect = Rect.fromLTWH(0, 0, 0, 0);
      check(rect.edges).deepEquals([]);
    });
  });

  group('rows', () {
    test('returns each row as a rect of height=1', () {
      // # # #
      // # # #
      // # # #
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.rows).deepEquals([
        Rect.fromLTWH(0, 0, 3, 1),
        Rect.fromLTWH(0, 1, 3, 1),
        Rect.fromLTWH(0, 2, 3, 1),
      ]);
    });
  });

  group('columns', () {
    test('returns each column as a rect of width=1', () {
      // # # #
      // # # #
      // # # #
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.columns).deepEquals([
        Rect.fromLTWH(0, 0, 1, 3),
        Rect.fromLTWH(1, 0, 1, 3),
        Rect.fromLTWH(2, 0, 1, 3),
      ]);
    });
  });

  group('positions', () {
    test('returns all positions in the rect', () {
      // # # #
      // # # #
      // # # #
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.positions).deepEquals([
        Pos(0, 0),
        Pos(1, 0),
        Pos(2, 0),
        Pos(0, 1),
        Pos(1, 1),
        Pos(2, 1),
        Pos(0, 2),
        Pos(1, 2),
        Pos(2, 2),
      ]);
    });

    test('returns no positions for an empty rect', () {
      final rect = Rect.fromLTWH(0, 0, 0, 0);
      check(rect.positions).deepEquals([]);
    });
  });

  group('contains', () {
    test('returns true for a position inside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.contains(Pos(1, 1))).isTrue();
    });

    test('returns false for a position outside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.contains(Pos(3, 3))).isFalse();
    });

    test('returns false for a position on the edge of the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      check(rect.contains(Pos(3, 2))).isFalse();
    });
  });

  group('containsRect', () {
    test('returns true for a rect inside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(1, 1, 1, 1);
      check(rect.containsRect(other)).isTrue();
    });

    test('returns false for a rect outside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(3, 3, 1, 1);
      check(rect.containsRect(other)).isFalse();
    });

    test('returns false for a rect on the edge of the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(2, 2, 2, 2);
      check(rect.containsRect(other)).isFalse();
    });
  });

  group('overlaps', () {
    test('returns true for a rect inside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(1, 1, 1, 1);
      check(rect.overlaps(other)).isTrue();
    });

    test('returns true for a rect outside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(2, 2, 2, 2);
      check(rect.overlaps(other)).isTrue();
    });

    test('returns true for a rect on the edge of the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(2, 2, 1, 1);
      check(rect.overlaps(other)).isTrue();
    });

    test('returns false for a rect outside the rect', () {
      final rect = Rect.fromLTWH(0, 0, 3, 3);
      final other = Rect.fromLTWH(3, 3, 1, 1);
      check(rect.overlaps(other)).isFalse();
    });
  });

  test('translate adds a pos as an offset', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.translate(Pos(5, 10))).equals(Rect.fromLTWH(15, 30, 30, 40));
  });

  group('intersect', () {
    test('returns the intersection of two rects', () {
      final a = Rect.fromLTWH(0, 0, 3, 3);
      final b = Rect.fromLTWH(1, 1, 3, 3);
      check(a.intersect(b)).equals(Rect.fromLTWH(1, 1, 2, 2));
    });

    test('returns an empty rect if there is no intersection', () {
      final a = Rect.fromLTWH(0, 0, 3, 3);
      final b = Rect.fromLTWH(3, 3, 3, 3);
      check(a.intersect(b)).has((b) => b.isEmpty, 'isEmpty').isTrue();
    });
  });

  test('inflate', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.inflate(5)).equals(Rect.fromLTWH(5, 15, 40, 50));
  });

  test('deflate', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.deflate(5)).equals(Rect.fromLTWH(15, 25, 20, 30));
  });

  group('normalize', () {
    test('no effect on a normal rect', () {
      final rect = Rect.fromLTWH(10, 20, 30, 40);
      check(rect.normalize()).equals(Rect.fromLTWH(10, 20, 30, 40));
    });

    test('right < left swaps left and right', () {
      final rect = Rect.fromLTRB(30, 20, 10, 40);
      check(rect.normalize()).equals(Rect.fromLTRB(10, 20, 30, 40));
    });

    test('bottom < top swaps top and bottom', () {
      final rect = Rect.fromLTRB(10, 40, 30, 20);
      check(rect.normalize()).equals(Rect.fromLTRB(10, 20, 30, 40));
    });
  });

  test('hashCode', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.hashCode).equals(rect.hashCode);
  });

  test('toString', () {
    final rect = Rect.fromLTWH(10, 20, 30, 40);
    check(rect.toString()).equals('Rect.fromLTRB(10, 20, 40, 60)');
  });
}
