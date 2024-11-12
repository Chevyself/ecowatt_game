
// int CAMERA_SPEED = 12;
int MAX_CAMERA_SPEED = 8;
int MAX_ANIMATION_FRAME = 5; // Keep the animation for at least 5 frames

// Basically, the camera, is how far we've gone from
// the origin
int playerX = 640;
int playerY = 1408;

// Modal the player might be seeing
Modal modal;

// Textures
PImage playerBackIdle;
PImage playerFrontIdle;
PImage playerRight;
PImage playerLeft;
PImage[] playerBackFrames;
PImage[] playerFrontFrames;
PImage[] playerRightFrames;
PImage[] playerLeftFrames;

// Last texture
PImage lastTexture;

// Animations
int animationFrame = 0;
int currentTextureFrame = 0;

void setupPlayer() {
  // Last texture will be the idle texture when setting up
  lastTexture = getIdleTexture();

  // Load the player textures
  loadPlayerTextures();
  // When reloaded, reload the player textures
  reloadTextureListeners.add(() -> loadPlayerTextures());
}

void loadPlayerTextures() {
  /*
  playerBackIdle = getTexture("playerBack");
  playerFrontIdle = getTexture("playerFront");
  playerRight = getTexture("playerRight");
  playerLeft = getTexture("playerRightMirror");
  playerBackFrames = getAnimationFrames("playerBackOn");
  playerFrontFrames = getAnimationFrames("playerFrontOn");
  playerRightFrames = getAnimationFrames("playerRightOn");
  playerLeftFrames = getAnimationFrames("playerRightOnMirror");*/
  playerBackIdle = getTextureAsImage("playerBack");
  playerFrontIdle = getTextureAsImage("playerFront");
  playerRight = getTextureAsImage("playerRight");
  playerLeft = getTextureAsImage("playerRightMirror");
  playerBackFrames = getAnimationFramesAsImages("playerBackOn");
  playerFrontFrames = getAnimationFramesAsImages("playerFrontOn");
  playerRightFrames = getAnimationFramesAsImages("playerRightOn");
  playerLeftFrames = getAnimationFramesAsImages("playerRightOnMirror");
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

PImage getIdleTexture() {
  switch (direction) {
    case UP:
      return playerBackIdle;
    case DOWN:
      return playerFrontIdle;
    case LEFT:
      return playerLeft;
    case RIGHT:
      return playerRight;
    default:
      return playerFrontIdle;
  }
}

PImage[] getFrames() {
  if (!moving) {
    return new PImage[0];
  }
  switch (direction) {
    case UP:
      return playerBackFrames;
    case DOWN:
      return playerFrontFrames;
    case LEFT:
      return playerLeftFrames;
    case RIGHT:
      return playerRightFrames;
    default:
      return new PImage[0];
  }
}

PImage getPositionTextures() {
  animationFrame++;
  animationFrame = animationFrame % MAX_ANIMATION_FRAME;
  if (animationFrame != 0) return null;

  //int texture[] = getIdleTexture();
  //int[][] frames = getFrames();
  PImage texture = getIdleTexture();
  PImage[] frames = getFrames();

  if (frames.length == 0) return texture;

  currentTextureFrame++;
  currentTextureFrame = currentTextureFrame % frames.length;
  return frames[currentTextureFrame];
}

void drawCharacter() {
  // Determinate the texture to draw
  // println("Drawing character")
  PImage textures = getPositionTextures();
  if (textures == null) {
    textures = lastTexture;
  } else {
    lastTexture = textures;
  }
  //println("Textures: " + textures.length);
  if (textures == null) return;
  // Draw
  int x = width / 2;
  int y = height / 2;
  image(textures, x, y);
}
