part of '../lodim.dart';

/// An immutable 2D fixed-point rectangle.
///
/// > [!NOTE]
/// > It is valid to have _any_ integer value for any of the edges.
/// >
/// > It is up to its consumers to ensure that the rectangle is valid for their
/// > use case. For example, [right] can be less than [left], or [bottom] can be
/// > negative.
///
/// ## Equality
///
/// A rectangle is defined by its [left], [top], [right], and [bottom] edges.
///
/// ## Example
///
/// Creating a rectangle:
///
/// ```dart
/// final rect = Rect.fromLTRB(0, 0, 10, 10);
/// ```
///
/// Using pattern matching to extract multiple values in one statement:
///
/// ```dart
/// final Rect(:left, :top, :right, :bottom) = rect;
/// ```
///
/// {@category Grids}
@immutable
final class Rect {
  /// Creates a rectangle from its left, top, right, and bottom edges.
  const Rect.fromLTRB(
    this.left,
    this.top,
    this.right,
    this.bottom,
  );

  /// Creates a rectangle from its left and top edges, and its width and height.
  const Rect.fromLTWH(
    int left,
    int top,
    int width,
    int height,
  ) : this.fromLTRB(left, top, left + width, top + height);

  /// Creates a rectangle from its top-left and bottom-right corners.
  ///
  /// This is equivalent to:
  /// ```dart
  /// Rect.fromLTRB(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);
  /// ```
  Rect.fromTLBR(
    Pos topLeft,
    Pos bottomRight,
  ) : this.fromLTRB(topLeft.x, topLeft.y, bottomRight.x, bottomRight.y);

  /// Creates the smallest rectangle that encloses the two provided positions.
  ///
  /// Imagine both [a] and [b] are points in a 2D plane. This method creates the
  /// smallest rectangle that encloses both points, regardless of their order.
  ///
  /// ## Example
  ///
  /// A simple example:
  ///
  /// ```dart
  /// final a = Pos(0, 0);
  /// final b = Pos(10, 10);
  /// final rect = Rect.encloses(a, b);
  /// print(rect); // Rect.fromLTRB(0, 0, 10, 10)
  /// ```
  ///
  /// Where `x` and `y` are more arbitrary:
  ///
  /// ```dart
  /// final a = Pos(5, 0);
  /// final b = Pos(0, 5);
  /// final rect = Rect.encloses(a, b);
  /// print(rect); // Rect.fromLTRB(0, 0, 5, 5)
  /// ```
  factory Rect.encloses(Pos a, Pos b) {
    final left = math.min(a.x, b.x);
    final top = math.min(a.y, b.y);
    final right = math.max(a.x, b.x);
    final bottom = math.max(a.y, b.y);
    return Rect.fromLTRB(left, top, right, bottom);
  }

  /// A comparator that sorts rectangle by their area.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Rect.fromLTWH(0, 0, 2, 2);
  /// final b = Rect.fromLTWH(0, 0, 3, 3);
  /// final c = Rect.fromLTWH(0, 0, 1, 1);
  /// final sorted = [a, b, c]..sort(Rect.byArea);
  /// print(sorted); // [Rect.fromLTWH(0, 0, 1, 1), Rect.fromLTWH(0, 0, 2, 2), Rect.fromLTWH(0, 0, 3, 3)]
  /// ```
  static const Comparator<Rect> byArea = _byArea;
  static int _byArea(Rect a, Rect b) => a.area.compareTo(b.area);

  /// A rectangle with all edges at 0.
  static const zero = Rect.fromLTRB(0, 0, 0, 0);

  /// The left, or x-coordinate of the left edge.
  final int left;

  /// The top, or y-coordinate of the top edge.
  final int top;

  /// The right, or x-coordinate of the right edge.
  final int right;

  /// The bottom, or y-coordinate of the bottom edge.
  final int bottom;

  /// The top-left corner of the rectangle.
  Pos get topLeft => Pos(left, top);

  /// The top-right corner of the rectangle.
  Pos get topRight => Pos(right, top);

  /// The bottom-left corner of the rectangle.
  Pos get bottomLeft => Pos(left, bottom);

  /// The bottom-right corner of the rectangle.
  Pos get bottomRight => Pos(right, bottom);

  /// The width of the rectangle.
  int get width => right - left;

  /// The height of the rectangle.
  int get height => bottom - top;

  /// Returns whether the rectangle is empty.
  ///
  /// A rectangle is considered empty if its width or height is <= 0.
  bool get isEmpty => width <= 0 || height <= 0;

  /// Returns whether the rectangle is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The area of the rectangle.
  int get area => width * height;

  /// The shortest side of the rectangle.
  int get shortestSide => math.min(width, height);

  /// The longest side of the rectangle.
  int get longestSide => math.max(width, height);

  /// Returns the center positions of the rectangle.
  ///
  /// For rectangles with an odd width and height, the center is a single
  /// point. For rectangles with an even width and/or height, the center is
  /// every point that is equidistant from the edges.
  ///
  /// An empty rectangle has no center and returns an empty list.
  ///
  /// ## Example
  ///
  /// Odd width and height:
  ///
  /// ```txt
  /// (0, 0) (1, 0) (2, 0)
  /// (0, 1) (1, 1) (2, 1)
  /// (0, 2) (1, 2) (2, 2)
  /// ```
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 3, 3);
  /// print(rect.center); // [Pos(1, 1)]
  /// ```
  ///
  /// Even width, odd height:
  ///
  /// ```txt
  /// (0, 0) (1, 0) (2, 0) (3, 0)
  /// (0, 1) (1, 1) (2, 1) (3, 1)
  /// (0, 2) (1, 2) (2, 2) (3, 2)
  /// ```
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 4, 3);
  /// print(rect.center); // [Pos(1, 1), Pos(2, 1)]
  /// ```
  ///
  /// Even width and height:
  ///
  /// ```txt
  /// (0, 0) (1, 0)
  /// (0, 1) (1, 1)
  /// ```
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// print(rect.center); // [Pos(0, 0), Pos(1, 0), Pos(0, 1), Pos(1, 1)]
  /// ```
  List<Pos> get center {
    if (isEmpty) {
      return [];
    }

    // Odd width and height? There is a true center.
    final flooredCenter = Pos(left + width ~/ 2, top + height ~/ 2);
    if (width.isOdd && height.isOdd) {
      return [flooredCenter];
    }

    // Even width and/or height? There are multiple centers.
    return [
      flooredCenter,
      if (width.isEven) flooredCenter + Pos(1, 0),
      if (height.isEven) flooredCenter + Pos(0, 1),
      if (width.isEven && height.isEven) flooredCenter + Pos(1, 1),
    ];
  }

  /// Returns the positions of the edges of the rectangle.
  ///
  /// The positions are ordered as follows:
  /// - Top edge, from left to right.
  /// - Right edge, from top to bottom.
  /// - Bottom edge, from right to left.
  /// - Left edge, from bottom to top.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// print(rect.edges); // [Pos(0, 0), Pos(1, 0), Pos(0, 1), Pos(1, 1), Pos(1, 0), Pos(1, 1), Pos(0, 1), Pos(0, 0)]
  /// ```
  Iterable<Pos> get edges => _EdgesIterable(this);

  /// Returns a rectangle for each _row_ in the rectangle.
  ///
  /// A row is a horizontal line that spans the width of the rectangle.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// print(rect.rows); // [Rect.fromLTWH(0, 0, 2, 1), Rect.fromLTWH(0, 1, 2, 1)]
  /// ```
  Iterable<Rect> get rows {
    return Iterable.generate(height, (y) {
      return Rect.fromLTWH(left, top + y, width, 1);
    });
  }

  /// Returns a rectangle for each _column_ in the rectangle.
  ///
  /// A column is a vertical line that spans the height of the rectangle.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// print(rect.columns); // [Rect.fromLTWH(0, 0, 1, 2), Rect.fromLTWH(1, 0, 1, 2)]
  /// ```
  Iterable<Rect> get columns {
    return Iterable.generate(width, (x) {
      return Rect.fromLTWH(left + x, top, 1, height);
    });
  }

  /// Returns the positions of the rectangle.
  ///
  /// The positions are ordered from the top-left corner to the bottom-right.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// print(rect.positions); // [Pos(0, 0), Pos(1, 0), Pos(0, 1), Pos(1, 1)]
  /// ```
  Iterable<Pos> get positions {
    return Iterable.generate(area, (i) {
      final x = left + i % width;
      final y = top + i ~/ width;
      return Pos(x, y);
    });
  }

  /// Returns whether the provided [position] is within the rectangle.
  ///
  /// Rectangles exclude their [right] and [bottom] edges.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// final position = Pos(1, 1);
  /// print(rect.contains(position)); // true
  ///
  /// final other = Pos(3, 3);
  /// print(rect.contains(other)); // false
  /// ```
  bool contains(Pos position) {
    return left <= position.x &&
        top <= position.y &&
        right > position.x &&
        bottom > position.y;
  }

  /// Returns whether the provided rectangle is within this rectangle.
  ///
  /// Rectangles exclude their [right] and [bottom] edges.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Rect.fromLTWH(0, 0, 2, 2);
  /// final b = Rect.fromLTWH(1, 1, 1, 1);
  /// print(a.containsRect(b)); // true
  ///
  /// final c = Rect.fromLTWH(3, 3, 2, 2);
  /// print(a.containsRect(c)); // false
  /// ```
  bool containsRect(Rect other) {
    return left <= other.left &&
        top <= other.top &&
        right >= other.right &&
        bottom >= other.bottom;
  }

  /// Returns whether the provided rectangle overlaps this rectangle.
  ///
  /// Rectangles exclude their [right] and [bottom] edges.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Rect.fromLTWH(0, 0, 2, 2);
  /// final b = Rect.fromLTWH(1, 1, 2, 2);
  /// print(a.overlaps(b)); // true
  ///
  /// final c = Rect.fromLTWH(3, 3, 2, 2);
  /// print(a.overlaps(c)); // false
  /// ```
  bool overlaps(Rect other) {
    return left < other.right &&
        right > other.left &&
        top < other.bottom &&
        bottom > other.top;
  }

  /// Returns a new rectangle translated by the provided position as an offset.
  ///
  /// The resulting rectangle has the same size as the original rectangle.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(0, 0, 2, 2);
  /// final offset = Pos(1, 1);
  /// final translated = rect.translate(offset);
  /// print(translated); // Rect.fromLTWH(1, 1, 3, 3)
  /// ```
  Rect translate(Pos offset) {
    return Rect.fromLTWH(left + offset.x, top + offset.y, width, height);
  }

  /// Returns the intersection of this rectangle and the provided rectangle.
  ///
  /// If the rectangles do not intersect, an empty rectangle is returned.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final a = Rect.fromLTWH(0, 0, 2, 2);
  /// final b = Rect.fromLTWH(1, 1, 2, 2);
  /// final intersection = a.intersect(b);
  /// print(intersection); // Rect.fromLTWH(1, 1, 1, 1)
  /// ```
  Rect intersect(Rect other) {
    final left = math.max(this.left, other.left);
    final top = math.max(this.top, other.top);
    final right = math.min(this.right, other.right);
    final bottom = math.min(this.bottom, other.bottom);
    return Rect.fromLTRB(left, top, right, bottom);
  }

  /// Returns a new rectangle with edges moved outwards by the provided [delta].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(1, 1, 2, 2);
  /// final inflated = rect.inflate(1);
  /// print(inflated); // Rect.fromLTWH(0, 0, 4, 4)
  /// ```
  Rect inflate(int delta) {
    return Rect.fromLTRB(
      left - delta,
      top - delta,
      right + delta,
      bottom + delta,
    );
  }

  /// Returns a new rectangle with edges moved inwards by the provided [delta].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final rect = Rect.fromLTWH(p, 0, 0, 4);
  /// final deflated = rect.deflate(1);
  /// print(deflated); // Rect.fromLTWH(1, 1, 2, 2)
  /// ```
  Rect deflate(int delta) => inflate(-delta);

  @override
  bool operator ==(Object other) {
    return other is Rect &&
        left == other.left &&
        top == other.top &&
        right == other.right &&
        bottom == other.bottom;
  }

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  String toString() => 'Rect.fromLTRB($left, $top, $right, $bottom)';
}

final class _EdgesIterable extends Iterable<Pos> {
  const _EdgesIterable(this._rect);

  final Rect _rect;

  @override
  Iterator<Pos> get iterator => _EdgesIterator(_rect);
}

final class _EdgesIterator implements Iterator<Pos> {
  _EdgesIterator(this._rect);

  final Rect _rect;

  @override
  Pos get current => _current;
  var _current = Pos.zero;
  Direction? _direction;

  @override
  bool moveNext() {
    if (_direction == null) {
      if (_rect.isEmpty) {
        return false;
      }
      _current = Pos(_rect.left, _rect.top);
      _direction = Direction.right;
      return true;
    }
    if (_direction == Direction.right) {
      if (_current.x < _rect.right - 1) {
        _current = Pos(_current.x + 1, _current.y);
        return true;
      }
      _direction = Direction.down;
    }

    if (_direction == Direction.down) {
      if (_current.y < _rect.bottom - 1) {
        _current = Pos(_current.x, _current.y + 1);
        return true;
      }
      _direction = Direction.left;
    }

    if (_direction == Direction.left) {
      if (_current.x > _rect.left) {
        _current = Pos(_current.x - 1, _current.y);
        return true;
      }
      _direction = Direction.up;
    }

    if (_direction == Direction.up) {
      if (_current.y > _rect.top + 1) {
        _current = Pos(_current.x, _current.y - 1);
        return true;
      }
    }

    return false;
  }
}
