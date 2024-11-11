import java.util.HashMap;
import java.util.Map;

public class Grid<T> {

  private final int size;
  private final Map<Vector2, T> cells;

  public Grid(int size, Map<Vector2, T> cells) {
    this.size = size;
    this.cells = cells;
  }

  public Grid(int size) {
    this(size, new HashMap<>());
  }

  public int size() {
    return size;
  }

  public T getCellData(Vector2 cell) {
    return cells.get(cell);
  }

  public T getCellData(int x, int y) {
    return getCellData(new Vector2(x, y));
  }

  public T getOrCreateCellData(Vector2 cell, T defaultValue) {
    return cells.computeIfAbsent(cell, k -> defaultValue);
  }

  public T getOrCreateCellData(int x, int y, T defaultValue) {
    return getOrCreateCellData(new Vector2(x, y), defaultValue);
  }

  public void loopThrough(
      int cameraX,
      int cameraY,
      int width,
      int height,
      float startX,
      float startY,
      float endX,
      float endY,
      boolean createIfNotExists,
      TriConsumer<Float, Float, T> consumer) {
    float alignedStartX = (float) Math.floor(startX / size) * size;
    float alignedStartY = (float) Math.floor(startY / size) * size;

    for (float x = alignedStartX; x <= endX; x += size) {
      for (float y = alignedStartY; y <= endY; y += size) {
        int cellX = (int) Math.floor(x / size);
        int cellY = (int) Math.floor(y / size);
        T t;
        if (createIfNotExists) {
          t = getOrCreateCellData(cellX, cellY, null);
        } else {
          t = getCellData(cellX, cellY);
        }
        if (t == null) {
          continue;
        }
        float screenX = x - cameraX + width / 2f;
        float screenY = y - cameraY + height / 2f;
        consumer.accept(screenX, screenY, t);
      }
    }
  }
}
