
class ModalElement extends CellData {
  String message = "";
  Runnable onClick = () -> {};
  boolean isButton = false;
}

class Modal {
  Grid<ModalElement> modalGrid = new Grid<ModalElement>(GRID_SIZE);
  boolean showModal = false;
  int selectedX = 0;
  int selectedY = 0;
  boolean isButtonSelected = false;
  Runnable postRender = () -> {};

  // Debounce
  long nextAllowedPress= 0;

  void setupModal(Runnable next) {
    modalGrid = new Grid<ModalElement>(GRID_SIZE);
    setupWalls();
    setupCorners();
    setupBackground();
    next.run();
  }

  void setupWalls() {
    int[] wall = getTexture("wall");
    int[] wall90 = getTexture("wall90");
    int[] wall180 = getTexture("wall180");
    int[] wall270 = getTexture("wall270");

    // Leave 1 for corners
    for (int i = -6; i < 6; i++) {
      modalGrid.getOrCreateCellData(i, -4, new ModalElement()).setTexture(wall, 0);
    }
    for (int i = -6; i < 6; i++) {
      modalGrid.getOrCreateCellData(i, 3, new ModalElement()).setTexture(wall180, 0);
    }
    for (int i = -3; i < 3; i++) {
      modalGrid.getOrCreateCellData(6, i, new ModalElement()).setTexture(wall270, 0);
    }
    for (int i = -3; i < 3; i++) {
      modalGrid.getOrCreateCellData(-7, i, new ModalElement()).setTexture(wall90, 0);
    }
  }

  void setupCorners() {
    int[] corner = getTexture("cornerSmall3");
    int[] corner90 = getTexture("cornerSmall390");
    int[] corner180 = getTexture("cornerSmall3180");
    int[] corner270 = getTexture("cornerSmall3270");

    modalGrid.getOrCreateCellData(6, -4, new ModalElement()).setTexture(corner, 0);
    modalGrid.getOrCreateCellData(6, 3, new ModalElement()).setTexture(corner270, 0);
    modalGrid.getOrCreateCellData(-7, 3, new ModalElement()).setTexture(corner180, 0);
    modalGrid.getOrCreateCellData(-7, -4, new ModalElement()).setTexture(corner90, 0);
  }

  void setupBackground() {
    int[] grass = getTexture("carpet");

    for (int x = -6; x <= 5; x++) {
      for (int y = -3; y <= 2; y++) {
        modalGrid.getOrCreateCellData(x, y, new ModalElement()).setTexture(grass, 0);
      }
    }
  }

  void render() {
    if (!showModal) {
      return;
    }
    float startX = 0 - width/2;
    float startY = 0 - height/2;
    float endX = 0 + width/2;
    float endY = 0 + height/2;
    modalGrid.loopThrough(
      0,
      0,
      width,
      height,
      startX,
      startY,
      endX,
      endY,
      false,
      (x, y, cell) -> {
        if (cell.isButton) {
          int gridX = (int) (x - width/2) / GRID_SIZE;
          int gridY = (int) (y - height/2) / GRID_SIZE;
          if (gridX == selectedX && gridY == selectedY && isButtonSelected) {
            // set color to black for text in selected button
            fill(0);
            cell.setTexture(getTexture("button"), 1);
          } else {
            cell.setTexture(getTexture("buttonOff"), 1);
          }
        }

        drawCellTexture(cell, x, y);
        textAlign(CENTER, CENTER);
        // text(cell.message, x, y);
        // x and y are min so we need to center it and place them a bit above
        float textX = x + GRID_SIZE/2;
        float textY = y + GRID_SIZE/2;
        text(cell.message, textX, textY);
        fill(255);
      });
      postRender.run();
  }

  void openModal() {
    if (showModal) {
      return;
    }
    showModal = true;
    soundOnOpenModal();
  }

  void closeModal() {
    if (!showModal) {
      return;
    }
    showModal = false;
    soundOnCloseModal();
  }

  void addButton(int x, int y, String message, Runnable onClick) {
    ModalElement cell = modalGrid.getOrCreateCellData(x, y, new ModalElement());
    cell.onClick = onClick;
    cell.message = message;
    cell.isButton = true;
    cell.setTexture(getTexture("button"), 1);
    if (!isButtonSelected) {
      selectedX = x;
      selectedY = y;
      isButtonSelected = true;
    }
  }

  void moveSelection(int dx, int dy) {
    if (!showModal || millis() < nextAllowedPress) {
      return;
    }
    nextAllowedPress = millis() + 200;

    // Store initial position to prevent infinite loop
    int startX = selectedX;
    int startY = selectedY;

    do {
      // Update position
      selectedX = wrapCoordinate(selectedX + dx, -6, 5);
      selectedY = wrapCoordinate(selectedY + dy, -3, 2);

      // Check if we found a valid button
      ModalElement cell = modalGrid.getCellData(selectedX, selectedY);
      if (cell != null && cell.isButton) {
          return;
      }
    } while (selectedX != startX || selectedY != startY);

    // If we complete the loop without finding a button,
    // restore original position
    selectedX = startX;
    selectedY = startY;
  }

  private int wrapCoordinate(int value, int min, int max) {
      if (value < min) return max;
      if (value > max) return min;
      return value;
  }

  void selectButton() {
    playClickSound();
    ModalElement cell = modalGrid.getCellData(selectedX, selectedY);
    if (cell == null) {
      return;
    }
    cell.onClick.run();
  }
}

/** Nice to have, can select buttons using mouse */
void mousePressed() {
  if (modal != null) {
    println("Checking modal");
    int gridX = (mouseX - width/2) / GRID_SIZE;
    int gridY = (mouseY - height/2) / GRID_SIZE;
    ModalElement cell = modal.modalGrid.getCellData(gridX, gridY);
    if (cell == null) {
      return;
    }
    cell.onClick.run();
  }
}
