import 'component.dart';
import 'element.dart';
import 'node.dart';

abstract class RenderTree<T> {
  Node get node;
}

class ElementRenderTree<T> extends RenderTree<T> {
  final Element element;
  final children = <RenderTree<T>>[];
  T nativeElement;

  ElementRenderTree(this.element);

  Node get node => element;
}

class ComponentRenderTree<T> extends RenderTree<T> {
  final Component component;
  final RenderTree<T> rendered;

  ComponentRenderTree(this.component, this.rendered);

  Node get node => component;

  ComponentRenderTree<T> withRendered(RenderTree<T> value) {
    return ComponentRenderTree(component, value);
  }
}
