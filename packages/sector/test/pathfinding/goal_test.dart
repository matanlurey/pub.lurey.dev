import '../prelude.dart';

void main() {
  test('Goal.test defers to a function', () {
    final goal = Goal.test((int node) => node == 1);

    check(goal.success(1)).isTrue();
    check(goal.success(2)).isFalse();
  });

  test('Goal.node matches a specific node', () {
    final goal = Goal.node(1);

    check(goal.success(1)).isTrue();
    check(goal.success(2)).isFalse();
  });

  test('Goal.never never matches any node', () {
    final goal = Goal<int>.never();

    check(goal.success(1)).isFalse();
    check(goal.success(2)).isFalse();
  });

  test('Goal.always always matches any node', () {
    final goal = Goal<int>.always();

    check(goal.success(1)).isTrue();
    check(goal.success(2)).isTrue();
  });

  test('Goal.any matches any of the goals in the list', () {
    final goal = Goal.any([
      Goal.node(1),
      Goal.node(2),
    ]);

    check(goal.success(1)).isTrue();
    check(goal.success(2)).isTrue();
    check(goal.success(3)).isFalse();
  });

  test('Goal.every matches all of the goals in the list', () {
    final goal = Goal.every([
      Goal.node(1),
      Goal.node(2),
    ]);

    check(goal.success(1)).isFalse();
    check(goal.success(2)).isFalse();
    check(goal.success(3)).isFalse();
  });
}
