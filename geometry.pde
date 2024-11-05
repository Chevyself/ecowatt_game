
/** The representation of a 2D vector with whole number components. */
class IntVector2D {
  int x;
  int y;

  IntVector2D(int x, int y) {
    this.x = x;
    this.y = y;
  }

  @Override
  int hashCode() {
    return x + y * 31;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null || getClass() != obj.getClass()) return false;
    IntVector2D other = (IntVector2D) obj;
    return x == other.x && y == other.y;
  }
}
