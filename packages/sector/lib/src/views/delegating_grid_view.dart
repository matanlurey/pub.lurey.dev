// This file is not tested; the API that matters is tested through other APIs.
// coverage:ignore-file

import 'package:meta/meta.dart';
import 'package:sector/sector.dart';

/// A base grid implementation that delegates all methods to another grid.
@internal
abstract base class DelegatingGridView<T> implements Grid<T> {
  /// Creates a new grid that delegates all methods to the provided view.
  const DelegatingGridView(this.view);

  @protected
  final Grid<T> view;

  @override
  int get width => view.width;

  @override
  int get height => view.height;

  @override
  bool get isEmpty => view.isEmpty;

  @override
  bool contains(T value) => view.contains(value);

  @override
  bool containsXY(int x, int y) => view.containsXY(x, y);

  @override
  bool containsXYWH(int x, int y, int width, int height) {
    return view.containsXYWH(x, y, width, height);
  }

  @override
  T get(int x, int y) => view.get(x, y);

  @override
  T getUnchecked(int x, int y) => view.getUnchecked(x, y);

  @override
  void set(int x, int y, T value) => view.set(x, y, value);

  @override
  void setUnchecked(int x, int y, T value) => view.setUnchecked(x, y, value);

  @override
  void clear() => view.clear();

  @override
  GridAxis<T> get rows => view.rows;

  @override
  GridAxis<T> get columns => view.columns;

  @override
  R traverse<R>(Traversal<R, T> order) {
    return view.traverse(order);
  }

  @override
  Grid<T> subGrid({
    int left = 0,
    int top = 0,
    int? width,
    int? height,
  }) {
    return view.subGrid(left: left, top: top, width: width, height: height);
  }

  @override
  Grid<T> asSubGrid({
    int left = 0,
    int top = 0,
    int? width,
    int? height,
  }) {
    return view.asSubGrid(left: left, top: top, width: width, height: height);
  }

  @override
  String toString() => view.toString();
}

@internal
base class DelegatingGridAxis<T> extends GridAxis<T> {
  const DelegatingGridAxis(this.view);

  @protected
  final GridAxis<T> view;

  @override
  Iterator<Iterable<T>> get iterator => view.iterator;

  @override
  set first(Iterable<T> cells) {
    view.first = cells;
  }

  @override
  set last(Iterable<T> cells) {
    view.last = cells;
  }

  @override
  void operator []=(int index, Iterable<T> cells) {
    view[index] = cells;
  }

  @override
  Iterable<T> operator [](int index) => view[index];

  @override
  void insertAt(int index, Iterable<T> cells) {
    view.insertAt(index, cells);
  }

  @override
  void insertFirst(Iterable<T> cells) {
    view.insertFirst(cells);
  }

  @override
  void insertLast(Iterable<T> cells) {
    view.insertLast(cells);
  }

  @override
  void removeAt(int index) {
    view.removeAt(index);
  }

  @override
  void removeFirst() {
    view.removeFirst();
  }

  @override
  void removeLast() {
    view.removeLast();
  }
}
