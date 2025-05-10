import 'package:armory/armory.dart';

void main() {
  // Copy on Write List.
  final originalList = List.generate(10, (index) => index);
  final copyOnWriteList = CopyOnWriteList(originalList);

  copyOnWriteList[0] = 100; // Modifying the copy
  print(originalList); // Original list remains unchanged
  print(copyOnWriteList); // Copy on write list reflects the change

  // Immutable Set.
  final aSet = ImmutableSet({1, 2, 3});
  final bSet = ImmutableSet({1, 2, 3});
  print(aSet == bSet); // true, because they are equal
  print(aSet.hashCode == bSet.hashCode); // true, because they are equal
}
