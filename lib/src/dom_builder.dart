abstract class DomBuilder<T> {
  void elementOpen(String tagName);
  void key(String value);
  void attr(String name, Object value);
  T elementClose();
}
