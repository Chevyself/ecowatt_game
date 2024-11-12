import java.util.HashMap;
import java.util.Map;

public class Grid<T extends ICellData> {

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

  public void debugCollision(int worldX, int worldY, int hitboxSize) {
    int halfSize = hitboxSize / 2;

    int entityLeft = worldX - halfSize;
    int entityRight = worldX + halfSize;
    int entityTop = worldY - halfSize;
    int entityBottom = worldY + halfSize;

    int minGridX = Math.floorDiv(entityLeft, size);
    int maxGridX = Math.floorDiv(entityRight + (size - 1), size);
    int minGridY = Math.floorDiv(entityTop, size);
    int maxGridY = Math.floorDiv(entityBottom + (size - 1), size);

    System.out.println("Entity bounds: (" + entityLeft + "," + entityTop + ") to (" +
      entityRight + "," + entityBottom + ")");
    System.out.println("Grid bounds: (" + minGridX + "," + minGridY + ") to (" +
      maxGridX + "," + maxGridY + ")");

    for (int gridX = minGridX; gridX <= maxGridX; gridX++) {
      for (int gridY = minGridY; gridY <= maxGridY; gridY++) {
        T cellData = getCellData(gridX, gridY);
        if (cellData.isObstacle()) {
          int obstacleLeft = gridX * size;
          int obstacleRight = obstacleLeft + size;
          int obstacleTop = gridY * size;
          int obstacleBottom = obstacleTop + size;

          System.out.println("Checking obstacle at (" + gridX + "," + gridY + "): " +
            "(" + obstacleLeft + "," + obstacleTop + ") to (" +
            obstacleRight + "," + obstacleBottom + ")");
        }
      }
    }
  }

  /**
   * Checks if a point would collide with any obstacle in the grid
   * @param worldX The x coordinate in world space
   * @param worldY The y coordinate in world space
   * @param hitboxSize The size of the hitbox (usually equal to grid size)
   * @return true if the position is valid (no collision), false if there's a collision
   */
  public boolean isValidPosition(int worldX, int worldY, int hitboxSize) {
    // Calculate entity boundaries in world coordinates
    int halfSize = hitboxSize / 2;
    int entityLeft = worldX - halfSize;
    int entityRight = worldX + halfSize;
    int entityTop = worldY - halfSize;
    int entityBottom = worldY + halfSize;

    // Convert to grid coordinates using actual overlap, not potential overlap
    int minGridX = Math.floorDiv(entityLeft, size);
    int maxGridX = Math.floorDiv(entityRight, size);  // Removed the size-1 addition
    int minGridY = Math.floorDiv(entityTop, size);
    int maxGridY = Math.floorDiv(entityBottom, size);  // Removed the size-1 addition

    // Debug information
    System.out.println("Entity bounds: (" + entityLeft + "," + entityTop + ") to (" +
      entityRight + "," + entityBottom + ")");
    System.out.println("Grid bounds: (" + minGridX + "," + minGridY + ") to (" +
      maxGridX + "," + maxGridY + ")");

    // Check all potentially overlapping cells
    for (int gridX = minGridX; gridX <= maxGridX; gridX++) {
      for (int gridY = minGridY; gridY <= maxGridY; gridY++) {
        T cellData = getCellData(gridX, gridY);
        if (cellData.isObstacle()) {
          // Calculate obstacle boundaries in world coordinates
          int obstacleLeft = gridX * size;
          int obstacleRight = obstacleLeft + size;
          int obstacleTop = gridY * size;
          int obstacleBottom = obstacleTop + size;

          System.out.println("Checking obstacle at (" + gridX + "," + gridY + "): " +
            "(" + obstacleLeft + "," + obstacleTop + ") to (" +
            obstacleRight + "," + obstacleBottom + ")");

          // Check for actual overlap with a small tolerance
          final int TOLERANCE = 2; // Smaller tolerance for more precise detection
          boolean collides = entityLeft + TOLERANCE < obstacleRight &&
            entityRight - TOLERANCE > obstacleLeft &&
            entityTop + TOLERANCE < obstacleBottom &&
            entityBottom - TOLERANCE > obstacleTop;

          if (collides) {
            System.out.println("Collision detected!");
            return false;
          }
        }
      }
    }
    return true;
  }

  public boolean isValidPositionWithDistance(int worldX, int worldY, int hitboxSize, int minDistance) {
    int halfSize = hitboxSize / 2;
    int entityLeft = worldX - halfSize;
    int entityRight = worldX + halfSize;
    int entityTop = worldY - halfSize;
    int entityBottom = worldY + halfSize;

    // Calculate grid bounds with one extra cell to check nearby obstacles
    int minGridX = Math.floorDiv(entityLeft - minDistance, size);
    int maxGridX = Math.floorDiv(entityRight + minDistance, size);
    int minGridY = Math.floorDiv(entityTop - minDistance, size);
    int maxGridY = Math.floorDiv(entityBottom + minDistance, size);

    for (int gridX = minGridX; gridX <= maxGridX; gridX++) {
      for (int gridY = minGridY; gridY <= maxGridY; gridY++) {
        T cellData = getCellData(gridX, gridY);
        if (cellData.isObstacle()) {
          int obstacleLeft = gridX * size;
          int obstacleRight = obstacleLeft + size;
          int obstacleTop = gridY * size;
          int obstacleBottom = obstacleTop + size;

          // Calculate minimum distance between rectangles
          int dx = Math.max(0,
            Math.max(entityLeft - obstacleRight, obstacleLeft - entityRight));
          int dy = Math.max(0,
            Math.max(entityTop - obstacleBottom, obstacleTop - entityBottom));
          int distance = (int) Math.sqrt(dx * dx + dy * dy);

          if (distance < minDistance) {
            return false;
          }
        }
      }
    }
    return true;
  }

  public void loopThrough(
    int playerX,
    int playerY,
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
        float screenX = x - playerX + width / 2f;
        float screenY = y - playerY + height / 2f;
        consumer.accept(screenX, screenY, t);
      }
    }
  }
}
