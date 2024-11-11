
int GRID_SIZE = 128;
// 16x16 tiles
int TILE_SIZE = 16;

// Scale factor
float SCALE = (float) GRID_SIZE / TILE_SIZE;

// Load tiles image
PImage tiles;

// Preloaded pixels scaled to match the grid
HashMap<PVector, int[]> tilePixels = new HashMap<>();
// Some extra textures
HashMap<String, int[]> extras = new HashMap<>();

// Texture metadata
HashMap<String, TextureMetadata> textureMetadata = new HashMap<>();

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
  textureMetadata = new TextureMetadataLoader().load(dataPath("metadata"));
}

void computeTextures() {
  for (int x = 0; x < tiles.width; x += TILE_SIZE) {
    for (int y = 0; y < tiles.height; y += TILE_SIZE) {
      int[] computed = computeTilePixels(x, y);
      if (computed.length <= 0) {
        continue;
      }
      tilePixels.put(new PVector(x, y), computed);
      println("Texture loaded at " + x + ", " + y);
    }
  }
}

void loadExtraTextures() {
  // Wall is oriented down, so rotate it 90 degrees 3 times to complete
  int[] wall = getTilePixels(1, 0);
  extras.put("wall90", rotate90(wall));
  extras.put("wall180", rotate90(getExtraTexture("wall90")));
  extras.put("wall270", rotate90(getExtraTexture("wall180")));

  int[] corner = getTilePixels(2, 0);
  extras.put("corner90", rotate90(corner));
  extras.put("corner180", rotate90(getExtraTexture("corner90")));
  extras.put("corner270", rotate90(getExtraTexture("corner180")));

  // Player back left up, flips right
  extras.put("playerBackLeftUp", verticalFlip(playerBackRightUp()));

  // Left mirror
  extras.put("playerLeft", verticalFlip(playerRight()));
  extras.put("playerLeftWalk1", verticalFlip(playerRightWalk1()));
  extras.put("playerLeftWalk2", verticalFlip(playerRightWalk2()));
}

int[] getTilePixels(PVector position) {
  int[] value = tilePixels.get(position);
  // println("Tile at " + position.x + ", " + position.y + " is " + (value != null ? "loaded" : "not loaded"));
  return value != null ? value : fallback();
}

int[] getTilePixels(int x, int y) {
  int realX = x * TILE_SIZE;
  int realY = y * TILE_SIZE;
  return getTilePixels(new PVector(realX, realY));
}

int[] getExtraTexture(String name) {
  int[] value = extras.get(name);
  // println("Extra texture " + name + " is " + (value != null ? "loaded" : "not loaded"));
  return value != null ? value : fallback();
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

int[] horizontalFlip(int[] pixels) {
  int[] flipped = new int[pixels.length];
  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      flipped[i + (GRID_SIZE - j - 1) * GRID_SIZE] = pixels[i + j * GRID_SIZE];
    }
  }
  return flipped;
}

int[] verticalFlip(int[] pixels) {
  int[] flipped = new int[pixels.length];
  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      flipped[(GRID_SIZE - i - 1) + j * GRID_SIZE] = pixels[i + j * GRID_SIZE];
    }
  }
  return flipped;
}

// Generic types

int[] fallback() {
  return getTilePixels(0, 0);
}

int[] grass() {
  return getTilePixels(3, 0);
}

// Player

int[] playerFrontIdle() {
  return getTilePixels(0, 1);
}

int[] playerBackIdle() {
  return getTilePixels(0, 2);
}

int[] playerBackRightUp() {
  return getTilePixels(0, 3);
}

int[] playerBack() {
  return getTilePixels(0, 4);
}

int[] playerBackLeftUp() {
  return getExtraTexture("playerBackLeftUp");
}

int[] playerFrontRightUp() {
  return getTilePixels(0, 5);
}

int[] playerFront() {
  return getTilePixels(0, 6);
}

int[] playerFrontLeftUp() {
  return getTilePixels(0, 7);
}

int[] playerRight() {
  return getTilePixels(1, 1);
}

int[] playerRightWalk1() {
  return getTilePixels(1, 2);
}

int[] playerRightWalk2() {
  return getTilePixels(1, 3);
}

int[] playerLeft() {
  return getExtraTexture("playerLeft");
}

int[] playerLeftWalk1() {
  return getExtraTexture("playerLeftWalk1");
}

int[] playerLeftWalk2() {
  return getExtraTexture("playerLeftWalk2");
}

int[][] frontFrames() {
  return new int[][] {
    playerFrontLeftUp(),
    playerFront(),
    playerFrontRightUp(),
    playerFront()
  };
}

int[][] backFrames() {
  return new int[][] {
    playerBackLeftUp(),
    playerBack(),
    playerBackRightUp(),
    playerBack()
  };
}

int[][] leftFrames() {
  return new int[][] {
    playerLeftWalk1(),
    playerLeft(),
    playerLeftWalk2(),
    playerLeft(),
  };
}

int[][] rightFrames() {
  return new int[][] {
    playerRightWalk1(),
    playerRight(),
    playerRightWalk2(),
    playerRight(),
  };
}