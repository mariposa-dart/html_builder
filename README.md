# html_builder
[![version 1.0.1](https://img.shields.io/badge/pub-1.0.1-brightgreen.svg)](https://pub.dartlang.org/packages/html_builder)
[![build status](https://travis-ci.org/thosakwe/html_builder.svg)](https://travis-ci.org/thosakwe/html_builder)

Build HTML AST's and render them to HTML.

This can be used as an internal DSL, i.e. for a templating engine.

# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  html_builder: ^1.0.0
```

# Usage
```dart
import 'package:html_builder/html_builder.dart';

main() {
    // Akin to React.createElement(...);
    var $el = h('my-element', {}, []);


    // Attributes can be plain Strings.
    h('foo', {
        'bar': 'baz'
    });

    // Null attributes do not appear.
    h('foo', {
        'does-not-appear': null
    });

    // If an attribute is a bool, then it will only appear if its value is true.
    h('foo', {
        'appears': true,
        'does-not-appear': false
    });

    // Or, a String or Map.
    h('foo', {
        'style': 'background-color: white; color: red;'
    });

    h('foo', {
        'style': {
            'background-color': 'white',
            'color': 'red'
        }
    });

    // Or, a String or Iterable.
    h('foo', {
        'class': 'a b'
    });

    h('foo', {
        'class': ['a', 'b']
    });
}
```

Standard HTML5 elements:
```dart
import 'package:html_builder/elements.dart';

main() {
    var $dom = html(lang: 'en', children: [
        head(children: [
            title('Hello, world!')
        ]),
        body(children: [
            h1('Hello, world!'),
            p([text('Ok')])
        ])
    ]);
}
```

Rendering to HTML:
```dart
String html = new StringRenderer().render($dom);
```

Example with the [Angel](https://github.com/angel-dart/angel) server-side framework:

```dart
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:html_builder/elements.dart';

configureViews(Angel app) async {
    app.get('/foo', (req, res) async {
        var foo = await app.service('foo').read(req.params['id']);
        var $dom = html(children: [
            head(children: [
                title(foo.name)
            ]),
            body(children: [
                h1(children: [text(foo.name)])
            ])
        ]);

        res
          ..contentType = ContentType.HTML
          ..write(new StringRenderer().render($dom))
          ..end();
    });
}
```