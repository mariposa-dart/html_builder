/// Helper functions to build common HTML5 elements.
library html_builder.elements;

import 'html_builder.dart';

Node text(String text) => new TextNode(text);

Node a(
    {String href,
    String rel,
    String target,
    Map<String, dynamic> props: const {},
    Iterable<Node> children: const []}) {
  Map<String, dynamic> p = {}..addAll(props ?? {});

  if (href?.isNotEmpty == true) props['href'] = href;
  if (rel?.isNotEmpty == true) props['rel'] = rel;
  if (target?.isNotEmpty == true) props['target'] = target;

  return h('a', p, children ?? []);
}

Node body(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('body', props ?? {}, children ?? []);

Node div(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('div', props ?? {}, children ?? []);

Node form(
    {String action,
    String enctype,
    String method,
    Map<String, dynamic> props: const {},
    Iterable<Node> children: const []}) {
  Map<String, dynamic> p = {}..addAll(props ?? {});

  if (action?.isNotEmpty == true) props['action'] = action;
  if (enctype?.isNotEmpty == true) props['enctype'] = enctype;
  if (method?.isNotEmpty == true) props['method'] = method;

  return h('form', p, children ?? []);
}

Node h1(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('h1', props ?? {}, children ?? []);

Node h2(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('h2', props ?? {}, children ?? []);

Node h3(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('h1', props ?? {}, children ?? []);

Node h4(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('h4', props ?? {}, children ?? []);

Node h5(
        {Map<String, dynamic> props: const {},
        Iterable<Node> children: const []}) =>
    h('h5', props ?? {}, children ?? []);
