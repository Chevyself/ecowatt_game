enum Direction {
  UP, DOWN, LEFT, RIGHT
};

// HashMap<Character, Integer> keysPressed = new HashMap<>();
HashMap<Character, Boolean> keysPressed = new HashMap<>();
HashMap<Character, Integer> movementKeys = new HashMap<>();
Direction direction = Direction.DOWN;
boolean moving = false;

void keyPressed() {
  keyPressed(key);
  if (key == ESC) {
    key = 0;
  }
}

void keyPressed(char key) {
  switch (key) {
    case '4':
      debug = !debug;
      break;
    case '5':
      showTextures = !showTextures;
      break;
    case 'w':
    case 'a':
    case 's':
    case 'd':
      movementKeys.put(key, MAX_CAMERA_SPEED);
      break;
    case 'z':
      openPause();
      break;
    case 'c':
      openShop();
      break;
    case ESC:
      if (modal != null && modal.showModal) {
        modal.closeModal();
        modal = null;
        return;
      }
      if (placingFurniture != null) {
        resetPlacingFurniture();
        return;
      }
      openPause();
      break;
    default:
      keysPressed.put(key, true);
      break;
  }
}

void openPause() {
  if (modal != null && modal.showModal) {
    return;
  }
  modal = new Modal();
  modal.setupModal(() -> {
    modal.addButton(-2, 0, "Puntaje", () -> {
      // TODO: Show score
    });
    modal.addButton(0, 0, "Continuar", () -> {
      modal.closeModal();
      modal = null;
    });
    modal.addButton(2, 0, "Salir", () -> {
      // DEMO so we wont exit! :p
      modal.closeModal();
      modal = null;
    });
    modal.openModal();
  });
}

void keyReleased() {
  keyReleased(key);
}

void keyReleased(char key) {
  switch (key) {
    case 'w':
    case 'a':
    case 's':
    case 'd':
      movementKeys.remove(key);
      checkIsMoving();
      break;
    default:
      keysPressed.remove(key);
      break;
  }
}

void checkIsMoving() {
  moving = movementKeys.values().stream().anyMatch(v -> v > 0);
}

boolean isKeyPressed(char key) {
  return Boolean.TRUE.equals(keysPressed.get(key));
}

void keybindsFrame() {
  if (modal != null && modal.showModal) {
    if (movementKeys.containsKey('w')) {
      modal.moveSelection(0, -1);
    } else if (movementKeys.containsKey('a')) {
      modal.moveSelection(-1, 0);
    } else if (movementKeys.containsKey('s')) {
      modal.moveSelection(0, 1);
    } else if (movementKeys.containsKey('d')) {
      modal.moveSelection(1, 0);
    }
    if (keysPressed.containsKey('x')) {
      modal.selectButton();
    }
    return;
  }

  if (placingFurniture != null) {
    if (movementKeys.containsKey('w')) {
      movePlacingFurniture(0, -movementKeys.get('w'));
    } else if (movementKeys.containsKey('a')) {
      movePlacingFurniture(-movementKeys.get('a'), 0);
    } else if (movementKeys.containsKey('s')) {
      movePlacingFurniture(0, movementKeys.get('s'));
    } else if (movementKeys.containsKey('d')) {
      movePlacingFurniture(movementKeys.get('d'), 0);
    }
    if (keysPressed.containsKey('v')) {
      attemptToPlaceFurniture();
    }
    return;
  }

  int xChange = 0;
  int yChange = 0;
  if (movementKeys.containsKey('w')) {
    yChange -= movementKeys.get('w');
    direction = Direction.UP;
    moving = true;
  } else if (movementKeys.containsKey('a')) {
    xChange -= movementKeys.get('a');
    direction = Direction.LEFT;
    moving = true;
  } else if (movementKeys.containsKey('s')) {
    yChange += movementKeys.get('s');
    direction = Direction.DOWN;
    moving = true;
  } else if (movementKeys.containsKey('d')) {
    xChange += movementKeys.get('d');
    direction = Direction.RIGHT;
    moving = true;
  }
  int nextX = playerX + xChange;
  int nextY = playerY + yChange;
  boolean notCollides = checkPlayerCollision(nextX, nextY);
  if (notCollides) {
   playerX = nextX;
   playerY = nextY;
  }
}
