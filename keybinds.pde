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
  if (keysPressed.containsKey('w')) {
    cameraY -= MAX_CAMERA_SPEED;
    direction = Direction.UP;
    moving = true;
  } else if (keysPressed.containsKey('a')) {
    cameraX -= MAX_CAMERA_SPEED;
    direction = Direction.LEFT;
    moving = true;
  } else if (keysPressed.containsKey('s')) {
    cameraY += MAX_CAMERA_SPEED;
    direction = Direction.DOWN;
    moving = true;
  } else if (keysPressed.containsKey('d')) {
    cameraX += MAX_CAMERA_SPEED;
    direction = Direction.RIGHT;
    moving = true;
  }
}
