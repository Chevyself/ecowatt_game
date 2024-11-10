
int CAMERA_SPEED = 12;
int MAX_ANIMATION_FRAME = 5; // Keep the animation for at least 5 frames

// Basically, the camera, is how far we've gone from
// the origin
int cameraX = 0;
int cameraY = 0;
int animationFrame = 0;
int currentTextureFrame = 0;

int[] lastTexture = new int[0];

void setupCamera() {
  lastTexture = getIdleTexture();
}

// draw on the center of the screen
/*
void drawCrossHair() {
  int x = width / 2;
  int y = height / 2;
  stroke(255, 0, 0);
  line(x - 10, y, x + 10, y);
  line(x, y - 10, x, y + 10);
}*/

int[] getIdleTexture() {
  switch (direction) {
    case UP:
      return playerBackIdle();
    case DOWN:
      return playerFrontIdle();
    case LEFT:
      return playerLeft();
    case RIGHT:
      return playerRight();
    default:
      return new int[0];
  }
}

int[][] getFrames() {
  if (!moving) {
    return new int[0][0];
  }
  switch (direction) {
    case UP:
      return backFrames();
    case DOWN:
      return frontFrames();
    case LEFT:
      return leftFrames();
    case RIGHT:
      return rightFrames();
    default:
      return new int[0][0];
  }
}

int[] getPositionTextures() {
  animationFrame++;
  animationFrame = animationFrame % MAX_ANIMATION_FRAME;
  if (animationFrame != 0) return new int[0];

  int texture[] = getIdleTexture();
  int[][] frames = getFrames();

  if (frames.length == 0) return texture;

  currentTextureFrame++;
  currentTextureFrame = currentTextureFrame % frames.length;
  return frames[currentTextureFrame];
}

void drawCharacter() {
  // Determinate the texture to draw
  // println("Drawing character")
  int[] textures = getPositionTextures();
  if (textures.length == 0) {
    textures = lastTexture;
  } else {
    lastTexture = textures;
  }
  println("Textures: " + textures.length);
  if (textures.length == 0) return;
  // Draw
  int x = width / 2 - GRID_SIZE / 2;
  int y = height / 2 - GRID_SIZE / 2;
  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      int index = i + j * GRID_SIZE;
      int pixel = textures[index];
      if (pixel != 0) {
        set(x + i, y + j, pixel);
      }
    }
  }
}