import 'package:lodim/lodim.dart';

void main() {
  final pos = Pos(4, 2);
  final direction = Direction.right;
  print(pos + direction); // => Pos(5, 2)
  print(pos + direction * 3); // => Pos(7, 2)

  final rect = Rect.fromLTRB(4, 2, 7, 4);
  print(rect.topLeft); // => Pos(4, 2)
  print(rect.bottomRight); // => Pos(7, 4)
  print(rect.width); // => 3
  print(rect.height); // => 2

  final other = Rect.fromLTRB(6, 3, 8, 5);
  print(rect.contains(Pos(5, 3))); // => true
  print(rect.intersect(other)); // => Rect.fromLTRB(6, 3, 7, 4)
  for (final edge in rect.edges) {
    print(edge); // => Pos(x, y)
  }

  final a = Pos(10, 20);
  final b = Pos(30, 40);
  print(a.distanceTo(b, using: euclideanSquared)); // => 500
  print(a.distanceTo(b, using: manhattan)); // => 40

  final rotated = pos.rotate90();
  print(rotated); // => Pos(-2, 4)
  print(Direction.right); // => Pos(1, 0)

  for (final p in a.lineTo(b)) {
    print(p);
  }
}
