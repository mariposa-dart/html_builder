import 'package:collection/collection.dart';

/// Shorthand function to generate a new [Node].
Node h(String tagName,
        [Map<String, dynamic> attributes = const {},
        Iterable<Node> children = const []]) =>
    new Node(tagName, attributes, children);

/// Represents an HTML node.
class Node {
  final String tagName;
  final Map<String, dynamic> attributes = {};
  final List<Node> children = [];

  Node(this.tagName,
      [Map<String, dynamic> attributes = const {},
      Iterable<Node> children = const []]) {
    this..attributes.addAll(attributes)..children.addAll(children);
  }

  Node._selfClosing(this.tagName,
      [Map<String, dynamic> attributes = const {}]) {
    this..attributes.addAll(attributes);
  }

  @override
  bool operator ==(other) {
    return other is Node &&
        other.tagName == tagName &&
        const ListEquality<Node>().equals(other.children, children) &&
        const MapEquality<String, dynamic>()
            .equals(other.attributes, attributes);
  }
}

/// Represents a self-closing tag, i.e. `<br>`.
class SelfClosingNode extends Node {
  final String tagName;
  final Map<String, dynamic> attributes = {};

  @override
  List<Node> get children => new List<Node>.unmodifiable([]);

  SelfClosingNode(this.tagName, [Map<String, dynamic> attributes = const {}])
      : super._selfClosing(tagName, attributes);
}

/// Represents a text node.
class TextNode extends Node {
  final String text;

  TextNode(this.text) : super(':text');

  @override
  bool operator ==(other) => other is TextNode && other.text == text;
}
