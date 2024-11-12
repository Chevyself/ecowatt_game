enum Direction {
  UP, DOWN, LEFT, RIGHT
};

HashMap<Character, Integer> keysPressed = new HashMap<>();
Direction direction = Direction.DOWN;
boolean moving = false;

// Toggle debug and textures with keys
void keyPressed() {
  if (key == '4') {
    debug = !debug;
  } else if (key == '5') {
    showTextures = !showTextures;
  }
  keysPressed.put(key, MAX_CAMERA_SPEED);
}

void keyPressed(char key) {
  keysPressed.put(key, MAX_CAMERA_SPEED);
}

void keyReleased(char key) {
  keysPressed.remove(key);
  checkIsMoving();
}

void checkIsMoving() {
  moving = keysPressed.values().stream().anyMatch(v -> v > 0);
}

boolean isKeyPressed(char key) {
  return Boolean.TRUE.equals(keysPressed.get(key));
}

// This method is properly named as keyReleased
void keyReleased() {
  // keysPressed.put(key, false);
  // See if any movement key is still pressed
  keysPressed.remove(key);
  moving = keysPressed.values().stream().anyMatch(v -> v > 0);
}

void keybindsFrame() {
  /*
  if (Boolean.TRUE.equals(keysPressed.get('w'))) {
    cameraY -= CAMERA_SPEED;
    direction = Direction.UP;
    moving = true;
    return;
  }
  if (Boolean.TRUE.equals(keysPressed.get('a'))) {
    cameraX -= CAMERA_SPEED;
    direction = Direction.LEFT;
    moving = true;
    return;
  }
  if (Boolean.TRUE.equals(keysPressed.get('s'))) {
    cameraY += CAMERA_SPEED;
    direction = Direction.DOWN;
    moving = true;
    return;
  }
  if (Boolean.TRUE.equals(keysPressed.get('d'))) {
    cameraX += CAMERA_SPEED;
    direction = Direction.RIGHT;
    moving = true;
    return;
  }*/
  int xChange = 0;
  int yChange = 0;
  if (keysPressed.containsKey('w')) {
    // cameraY -= keysPressed.get('w');
    yChange -= keysPressed.get('w');
    direction = Direction.UP;
    moving = true;
  } else if (keysPressed.containsKey('a')) {
    // cameraX -= keysPressed.get('a');
    xChange -= keysPressed.get('a');
    direction = Direction.LEFT;
    moving = true;
  } else if (keysPressed.containsKey('s')) {
    // cameraY += keysPressed.get('s');
    yChange += keysPressed.get('s');
    direction = Direction.DOWN;
    moving = true;
  } else if (keysPressed.containsKey('d')) {
    // cameraX += keysPressed.get('d');
    xChange += keysPressed.get('d');
    direction = Direction.RIGHT;
    moving = true;
  }
  int nextX = cameraX + xChange;
  int nextY = cameraY + yChange;
  boolean notCollides = checkPlayerCollision(nextX, nextY);
  if (notCollides) {
   cameraX = nextX;
   cameraY = nextY;
  }
}
