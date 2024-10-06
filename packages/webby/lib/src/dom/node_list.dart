part of '../../webby.dart';

/// Collections of nodes returned by properties such as [Node.childNodes].
extension type NodeList<E extends Node>._(JSObject _)
    implements _UnmodifiableList<E> {}
