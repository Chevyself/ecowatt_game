
int GRID_SIZE = 128;
// 16x16 tiles
int TILE_SIZE = 16;

// Scale factor
float SCALE = (float) GRID_SIZE / TILE_SIZE;

// Load tiles image
PImage tiles;

// Texture metadata
HashMap<String, TextureMetadata> textureMetadata = new HashMap<>();
// Preloaded pixels scaled to match the grid
HashMap<PVector, int[]> tilePixels = new HashMap<>();
// Textures identified by a key
HashMap<String, int[]> textures = new HashMap<>();
// Animation identified by a key
HashMap<String, Animation> animations = new HashMap<>();
// Fallback
int[] fallback = new int[0];

// Reload listeners
ArrayList<Runnable> reloadTextureListeners = new ArrayList<>();

class Animation {
  int[][] frames;
  int speed; // How long a frame lasts

  Animation(int[][] frames, int speed) {
    this.frames = frames;
    this.speed = speed;
  }
}

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
  computeTextures();
  textureMetadata = new TextureMetadataLoader().load(dataPath("metadata"));
  fallback = getTilePixels(0, 0);
  metadataToTextures();
  reloadTextureListeners.forEach(Runnable::run);
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

int[] getTilePixels(PVector position) {
  int[] value = tilePixels.get(position);
  // println("Tile at " + position.x + ", " + position.y + " is " + (value != null ? "loaded" : "not loaded"));
  return value != null ? value : fallback;
}

int[] getTilePixels(int x, int y) {
  int realX = x * TILE_SIZE;
  int realY = y * TILE_SIZE;
  return getTilePixels(new PVector(realX, realY));
}

int[] getTexture(String key) {
  int[] val = textures.get(key);
  return val != null ? val : fallback;
}

PImage getTextureAsImage(String key) {
  return pixelsToImage(getTexture(key));
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

int[][] getAnimationFrames(String key) {
  Animation animation = animations.get(key);
  return animation != null ? animation.frames : new int[0][0];
}

PImage[] getAnimationFramesAsImages(String key) {
  return framesToImages(getAnimationFrames(key));
}

void metadataToTextures() {
  textureMetadata.forEach((key, metadata) -> {
    int[] pixels = getTilePixels(metadata.getX(), metadata.getY());
    textures.put(key, pixels);

    // Rotations
    int rotationDeg = 90;
    for (int i = 0; i < metadata.getRotations(); i++) {
      pixels = rotate90(pixels);
      textures.put(key + rotationDeg, pixels);
      if (metadata.isMirror()) {
        int[] mirrored = horizontalFlip(pixels);
        println("Mirrored texture: " + key + rotationDeg + "Mirror");
        textures.put(key + rotationDeg + "Mirror", pixels);
      }
      rotationDeg += 90;
    }
    rotationDeg = 90;
    // Animations
    HashMap<String, Animation> metadataAnimations = metadataToAnimations(metadata);
    animations.putAll(metadataAnimations);

    // Mirror
    if (metadata.isMirror()) {
      pixels = verticalFlip(getTilePixels(metadata.getX(), metadata.getY()));
      textures.put(key + "Mirror", pixels);

      // Mirror animations
      metadataAnimations.forEach((animationKey, animation) -> {
        int[][] mirroredFrames = mirrorAnimation(animation.frames);
        println("Mirrored frames: " + mirroredFrames.length + " in " + animationKey);
        animations.put(animationKey + "Mirror", new Animation(mirroredFrames, animation.speed));
      });
    }
  });
}

HashMap<String, Animation> metadataToAnimations(TextureMetadata metadata) {
  String key = metadata.getKey();
  int speed = metadata.getAnimationSpeed();
  HashMap<String, Animation> animations = new HashMap<>();
  int[][] onFrames = coordinatesToAnimation(metadata.getAnimationOn(), metadata.isAnimationMirror());
  if (onFrames.length > 0) {
    animations.put(key + "On", new Animation(onFrames, speed));
  }
  int[][] offFrames = coordinatesToAnimation(metadata.getAnimationOff(), metadata.isAnimationMirror());
  if (offFrames.length > 0) {
    animations.put(key + "Off", new Animation(offFrames, speed));
  }
  int[][] startFrames = coordinatesToAnimation(metadata.getAnimationStart(), metadata.isAnimationMirror());
  if (startFrames.length > 0) {
    animations.put(key + "Start", new Animation(startFrames, speed));
  }
  int[][] endFrames = coordinatesToAnimation(metadata.getAnimationEnd(), metadata.isAnimationMirror());
  if (endFrames.length > 0) {
    animations.put(key + "End", new Animation(endFrames, speed));
  }
  return animations;
}

int[][] coordinatesToAnimation(ArrayList<Vector2> coordinates, boolean mirror) {
  if (coordinates.size() == 0) {
    return new int[0][0];
  }
  int size = coordinates.size();
  if (mirror) {
    size *= 2;
  }
  int[][] frames = new int[size][GRID_SIZE * GRID_SIZE];
  for (int i = 0; i < coordinates.size(); i++) {
    Vector2 coord = coordinates.get(i);
    int[] pixels = getTilePixels(coord.getX(), coord.getY());
    frames[i] = pixels;
    if (mirror) {
      frames[size - i - 1] = verticalFlip(pixels);
    }
  }
  return frames;
}

// Mirrors the animation for instance player going right to go left
int[][] mirrorAnimation(int[][] frames) {
  int[][] mirrored = new int[frames.length][GRID_SIZE * GRID_SIZE];
  for (int i = 0; i < frames.length; i++) {
    mirrored[i] = verticalFlip(frames[i]);
  }
  return mirrored;
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

PImage pixelsToImage(int[] pixels) {
  PImage image = createImage(GRID_SIZE, GRID_SIZE, ARGB);
  image.loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    image.pixels[i] = pixels[i];
  }
  image.updatePixels();
  return image;
}

PImage[] framesToImages(int[][] frames) {
  PImage[] images = new PImage[frames.length];
  for (int i = 0; i < frames.length; i++) {
    images[i] = pixelsToImage(frames[i]);
  }
  return images;
}