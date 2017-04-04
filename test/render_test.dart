import 'package:html/parser.dart' as html;
import 'package:html_builder/elements.dart';
import 'package:html_builder/html_builder.dart';
import 'package:test/test.dart';

main() {
  test('pretty', () {
    var $dom = h('html', {
      'lang': 'en'
    }, [
      h('head', {}, [
        h('title', {}, [text('Hello, world!')])
      ]),
      h('body', {
        'unresolved': true
      }, [
        h('h1', {}, [text('Hello, world!')])
      ])
    ]);

    var rendered = new StringRenderer().render($dom);
    print(rendered);

    var $parsed = html.parse(rendered);
    var title = $parsed.querySelector('title');
    expect(title.text.trim(), 'Hello, world!');
    var h1 = $parsed.querySelector('h1');
    expect(h1.text.trim(), 'Hello, world!');
  });
}
