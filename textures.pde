// 16x16 tiles
int TILE_SIZE = 16;
// Scale factor
float SCALE = (float)GRID_SIZE / TILE_SIZE;

// Load tiles image
PImage tiles;

// Preloaded pixels scaled to match the grid
HashMap<IntVector2D, int[]> tilePixels = new HashMap<>();

/** Returns the scaled pixels of the tile at the given position, based on the whole tiles image.
 *  Use #getTilePixels(int, int) to get the pixels of a tile at a specific position using cached values.
 */
int[] computeTilePixels(int x, int y) {
  int[] scaledPixels = new int[GRID_SIZE * GRID_SIZE];

  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      int sourceX = (int)(x + (i / SCALE));
      int sourceY = (int)(y + (j / SCALE));

      int sourcePixel = tiles.pixels[sourceX + sourceY * tiles.width];

      scaledPixels[i + j * GRID_SIZE] = sourcePixel;
    }
  }
  return scaledPixels;
}

/** Reloads all the possible textures and scale them by calculating the cell size using GRID_SIZE */
void reloadTextures() {
  tilePixels.clear();
  for (int x = 0; x < tiles.width; x += TILE_SIZE) {
    for (int y = 0; y < tiles.height; y += TILE_SIZE) {
      tilePixels.put(new IntVector2D(x, y), computeTilePixels(x, y));
      // println("Texture loaded at " + x + ", " + y);
    }
  }
}

int[] getTilePixels(IntVector2D position) {
  return tilePixels.get(position);
}

int[] getTilePixels(int x, int y) {
  return getTilePixels(new IntVector2D(x, y));
}
