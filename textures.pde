
// 16x16 tiles
int TILE_SIZE = 16;

// Scale factor
float SCALE = (float) GRID_SIZE / TILE_SIZE;

// Load tiles image
PImage tiles;

// Preloaded pixels scaled to match the grid
HashMap<IntVector2D, int[]> tilePixels = new HashMap<>();
// Some extra textures
HashMap<String, int[]> extras = new HashMap<>();

/** Returns the scaled pixels of the tile at the given position, based on the whole tiles image.
 *  Use #getTilePixels(int, int) to get the pixels of a tile at a specific position using cached values.
 */
int[] computeTilePixels(int x, int y) {
  int[] scaledPixels = new int[GRID_SIZE * GRID_SIZE];
  boolean isEmpty = true;

  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      int sourceX = (int)(x + (i / SCALE));
      int sourceY = (int)(y + (j / SCALE));

      int sourcePixel = tiles.pixels[sourceX + sourceY * tiles.width];
      // Check if the pixel is not transparent
      if (sourcePixel != 0) {
        isEmpty = false;
      }

      scaledPixels[i + j * GRID_SIZE] = sourcePixel;
    }
  }
  return isEmpty ? new int[0] : scaledPixels;
}

/** Reloads all the possible textures and scale them by calculating the cell size using GRID_SIZE */
void reloadTextures() {
  tilePixels.clear();
  extras.clear();
  computeTextures();
  loadExtraTextures();
}

void computeTextures() {
  for (int x = 0; x < tiles.width; x += TILE_SIZE) {
    for (int y = 0; y < tiles.height; y += TILE_SIZE) {
      int[] computed = computeTilePixels(x, y);
      if (computed.length <= 0) {
        continue;
      }
      tilePixels.put(new IntVector2D(x, y), computed);
      println("Texture loaded at " + x + ", " + y);
    }
  }
}

void loadExtraTextures() {
  // Wall is oriented down, so rotate it 90 degrees 3 times to complete
  int[] wall = getTilePixels(1, 0);
  extras.put("wall90", rotate90(wall));
  extras.put("wall180", rotate90(extras.get("wall90")));
  extras.put("wall270", rotate90(extras.get("wall180")));
}

int[] getTilePixels(IntVector2D position) {
  int[] value = tilePixels.get(position);
  return value != null ? value : fallback();
}

int[] getTilePixels(int x, int y) {
  int realX = x * TILE_SIZE;
  int realY = y * TILE_SIZE;
  return getTilePixels(new IntVector2D(realX, realY));
}

int[] fallback() {
  return getTilePixels(0, 0);
}

int[] rotate90(int[] pixels) {
  int[] rotated = new int[pixels.length];
  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      rotated[j + (GRID_SIZE - i - 1) * GRID_SIZE] = pixels[i + j * GRID_SIZE];
    }
  }
  return rotated;
}