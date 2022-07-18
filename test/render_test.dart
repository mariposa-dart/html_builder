import 'package:html/parser.dart' as html5;
import 'package:html_builder/elements.dart';
import 'package:test/test.dart';

main() {
  test('title', () {
    var $dom = html(
      lang: 'en',
      c: [
        head(c: [
          title(c: [text('Hello, world!')])
        ])
      ],
    );

    var rendered = new StringRenderer().render($dom);
    print(rendered);

    var $parsed = html5.parse(rendered);
    var $title = $parsed.querySelector('title')!;
    expect($title.text.trim(), 'Hello, world!');
  });
  test('text', () {
    var $dom = html(
      c: [
        body(
          p: {'unresolved': true},
          c: [
            h1(c: [text('<p>Hello, world!</p>')]),
            br(),
            hr(),
          ],
        )
      ],
    );

    var rendered = new StringRenderer().render($dom);
    print(rendered);

    var $parsed = html5.parse(rendered);
    var $h1 = $parsed.querySelector('h1')!;
    expect($h1.text.trim(), '<p>Hello, world!</p>');
  });
  test('innerHtml', () {
    var $dom = html(
      c: [
        body(
          c: [
            h1(c: [innerHtml('<b>Hello, world!</b>')]),
          ],
        )
      ],
    );

    var rendered = new StringRenderer().render($dom);
    print(rendered);

    var $parsed = html5.parse(rendered);
    var $h1 = $parsed.querySelector('h1>b')!;
    expect($h1.text.trim(), 'Hello, world!');
  });
}
