enum Direction {
  UP, DOWN, LEFT, RIGHT
};

HashMap<Character, Boolean> keysPressed = new HashMap<>();
Direction direction = Direction.DOWN;
boolean moving = false;

// Toggle debug and textures with keys
void keyPressed() {
  if (key == '4') {
    debug = !debug;
  } else if (key == '5') {
    showTextures = !showTextures;
  }
  keysPressed.put(key, true);
}

boolean isKeyPressed(char key) {
  return Boolean.TRUE.equals(keysPressed.get(key));
}

// This method is properly named as keyReleased
void keyReleased() {
  keysPressed.put(key, false);
  // See if any movement key is still pressed
  moving = isKeyPressed('w') || isKeyPressed('a') || isKeyPressed('s') || isKeyPressed('d');
}

void keybindsFrame() {
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
  }
}
