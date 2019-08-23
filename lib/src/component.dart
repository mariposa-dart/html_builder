import 'dom_builder.dart';
import 'node.dart';

abstract class Component extends Node {
  String get tagName => null;
  final String key;
  Component({this.key});
  void initialize() => null;
  void deactivate() => null;
  Node render();
}
