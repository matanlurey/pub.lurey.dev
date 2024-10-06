part of '../../webby.dart';

/// Abstract base class which many other DOM API objects are based on.
///
/// ---
///
/// See <https://developer.mozilla.org/en-US/docs/Web/API/Node>.
extension type Node._(JSObject _) implements EventTarget {
  /// Live collection of child nodes of the given element.
  external NodeList get childNodes;

  /// First direct child node of the given node, or `null` if no child exists.
  external Node? get firstChild;

  /// Whether the node is connected to the context object.
  external JSBoolean get isConnected;

  /// Last direct child node of the given node, or `null` if no child exists.
  external Node? get lastChild;

  /// Next sibling of the given node, or `null` if no sibling exists.
  external Node? get nextSibling;

  /// Previous sibling of the given node, or `null` if no sibling exists.
  external Node? get previousSibling;

  /// Name of the node.
  external JSString get nodeName;

  /// Type of the node.
  external JSNumber get nodeType;

  /// Value of the node.
  external JSString nodeValue;

  /// Document object of the node, or `null` if not part of a document.
  external Document? get ownerDocument;

  /// Parent node of the given node, or `null` if no parent exists.
  external Node? get parentNode;

  /// Parent element of the given node, or `null` if no parent exists or it is
  /// not an element.
  external Element? get parentElement;

  /// Text content of the node.
  external JSString textContent;

  /// Append a child node to the given node.
  external T appendChild<T extends Node>(T node);

  /// Clone the node and its contents.
  external Node cloneNode([JSBoolean deep]);

  /// Compare the position of the given node relative to another node.
  external JSNumber compareDocumentPosition(Node other);

  /// Whether the node contains another node.
  external JSBoolean contains(Node other);

  /// Returns the object's root.
  Node getRootNode({bool composed = false}) {
    if (composed) {
      return _getRootNode(_GetRootNodeOptions(composed: true.toJS));
    }
    return _getRootNode();
  }

  @JS('getRootNode')
  external Node _getRootNode([_GetRootNodeOptions options]);

  /// Whether the node has child nodes.
  external JSBoolean hasChildNodes();

  /// Insert a node before another node.
  external T insertBefore<T extends Node>(T node, Node? child);

  /// Returns whether the given namespace is the default namespace of the node.
  external JSBoolean isDefaultNamespace(JSString namespace);

  /// Returns whether the given node is equal to the current node.
  external JSBoolean isEqualNode(Node other);

  /// Returns whether the given node is the same as the current node.
  external JSBoolean isSameNode(Node other);

  /// Returns the namespace based on a prefix.
  external JSString lookupNamespaceURI(JSString prefix);

  /// Returns the prefix based on a namespace.
  external JSString lookupPrefix(JSString namespace);

  /// Puts the node into a normalized form.
  external void normalize();

  /// Remove a child node from the given node.
  external T removeChild<T extends Node>(T child);

  /// Replace a child node with another node.
  external T replaceChild<T extends Node>(T node, Node child);
}

extension type _GetRootNodeOptions._(JSObject _) implements JSObject {
  external factory _GetRootNodeOptions({JSBoolean composed});
}
