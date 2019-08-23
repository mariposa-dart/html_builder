import 'package:collection/collection.dart';
import 'component.dart';
import 'element.dart';
import 'dom_builder.dart';
import 'node.dart';
import 'render_tree.dart';

abstract class Renderer<T> {
  final DomBuilder<T> domBuilder;
  final Node root;
  RenderTree<T> _current;

  Renderer(this.domBuilder, this.root);

  void apply(RenderTree<T> rendered);

  void Function() render() {
    apply(_current = renderNode(root));
    return _rerender;
  }

  void _rerender() {
    var newRoot = renderNode(root);
    _current = diff(_current, newRoot);
  }

  RenderTree<T> renderNode(Node node) {
    if (node is Element) {
      return ElementRenderTree(node)
        ..children.addAll(node.children.map(renderNode));
    } else if (node is Component) {
      return ComponentRenderTree(node, renderNode(node.render()));
    } else {
      throw ArgumentError.value(
          node, 'node', 'must be an Element or Component');
    }
  }

  RenderTree<T> diff(RenderTree<T> oldTree, RenderTree<T> newTree) {
    // Four possible cases:
    // * old is Component, new is Component
    // * old is Component, new is Element
    // * old is Element, new is Element
    // * old is Element, new is Component

    if (oldTree is ComponentRenderTree<T>) {
      if (newTree is ComponentRenderTree<T>) {
        return diffTwoComponents(oldTree, newTree);
      } else if (newTree is ElementRenderTree<T>) {
        return diffComponentAndElement(oldTree, newTree);
      } else {
        throw ArgumentError.value(oldTree, 'newTree',
            'must be an ElementRenderTree or ComponentRenderTree');
      }
    } else if (oldTree is ElementRenderTree<T>) {
      if (newTree is ElementRenderTree<T>) {
        return diffTwoElements(oldTree, newTree);
      } else if (newTree is ComponentRenderTree<T>) {
        return diffElementAndComponent(oldTree, newTree);
      } else {
        throw ArgumentError.value(oldTree, 'newTree',
            'must be an ElementRenderTree or ComponentRenderTree');
      }
    } else {
      throw ArgumentError.value(oldTree, 'oldTree',
          'must be an ElementRenderTree or ComponentRenderTree');
    }
  }

  RenderTree<T> diffTwoComponents(
      ComponentRenderTree<T> a, ComponentRenderTree<T> b) {
    // If they are not the same type, OR the keys are different,
    // destroy the old one, and return the new, after initialization.
    if ((a.component.runtimeType != b.component.runtimeType) ||
        (a.component.key != b.component.key)) {
      destroyNode(a);
      initializeNode(b);
      return b;
    }

    // Otherwise, return the same node, and diff its rendered node.
    return a.withRendered(diff(a.rendered, b.rendered));
  }

  RenderTree<T> diffComponentAndElement(
      ComponentRenderTree<T> a, ElementRenderTree<T> b) {
    // Always destroy the component. Return the new node.
    destroyNode(a);
    initializeNode(b);
    return b;
  }

  RenderTree<T> diffTwoElements(
      ElementRenderTree<T> a, ElementRenderTree<T> b) {
    // If the tag name or key has changed, destroy the old node.
    if ((a.element.tagName != b.element.tagName) ||
        (a.element.key != b.element.key)) {
      destroyNode(a);
      initializeNode(b);
      return b;
    }

    // TODO: Otherwise, diff the children.
    var preserve = b.children;
    // var preserve = List<RenderTree<T>>.filled(b.children.length, null);

    // for (int i = 0; i < b.children.length && i < a.children.length; i++) {
    //   var oldChild = a.children[i];
    // }

    // preserve.removeWhere((t) => t == null);

    // for (int i = 0; i < b.children.length; i++) {
    //   preserve[i] = b.children[i];
    // }

    var newElement = Element(b.element.tagName,
        key: b.element.key,
        props: b.element.props,
        children: preserve.map((t) => t.node));
    return ElementRenderTree(newElement)..children.addAll(preserve);
  }

  RenderTree<T> diffElementAndComponent(
      ElementRenderTree<T> a, ComponentRenderTree<T> b) {
    // Always destroy the element. Return the new node.
    destroyNode(a);
    initializeNode(b);
    return b;
  }

  void destroyNode(RenderTree tree) {
    if (tree is ComponentRenderTree) {
      tree.component.deactivate();
      destroyNode(tree.rendered);
    } else if (tree is ElementRenderTree) {
      tree.children.forEach(destroyNode);
    } else {
      throw ArgumentError.value(
          tree, 'tree', 'must be an ElementRenderTree or ComponentRenderTree');
    }
  }

  void initializeNode(RenderTree tree) {
    if (tree is ComponentRenderTree) {
      tree.component.initialize();
      initializeNode(tree.rendered);
    } else if (tree is ElementRenderTree) {
      tree.children.forEach(initializeNode);
    } else {
      throw ArgumentError.value(
          tree, 'tree', 'must be an ElementRenderTree or ComponentRenderTree');
    }
  }
}
