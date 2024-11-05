
/** Replica of Java 8's BiConsumer interface. */
interface BiConsumer<T, U> {
  void accept(T t, U u);
}

class SimpleAtomic<T> {
  T value;

  SimpleAtomic(T value) {
    this.value = value;
  }

  T get() {
    return value;
  }

  void set(T value) {
    this.value = value;
  }
}