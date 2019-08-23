import 'node.dart';

class Element extends Node {
  final String tagName;
  final String key;
  final Map<String, dynamic> props;
  final Iterable<Node> children;

  const Element(this.tagName,
      {this.key, this.props = const {}, this.children = const []});
}
