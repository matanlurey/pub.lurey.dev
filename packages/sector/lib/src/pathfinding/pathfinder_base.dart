part of '../pathfinding.dart';

/// A base interface for pathfinding algorithms.
///
/// Most algorithms in this library are implemented in terms of pathfinding
/// algorithms, which are algorithms that find paths between nodes in a graph,
/// but there are three types of pathfinding algorithms which find...
///
/// - [Pathfinder], a path between two nodes.
/// - [BestPathfinder], the shortest path between two nodes.
/// - [HeuristicPathfinder], a path between two nodes using a heuristic.
///
/// This interface provides a common base class for all pathfinding algorithms,
/// allowing algorithms to be implemented in terms of [PathfinderBase] rather
/// than [Pathfinder], [BestPathfinder], or [HeuristicPathfinder] specifically
/// if they support all three types.
sealed class PathfinderBase<E> {}
