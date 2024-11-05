// Grid manager
int GRID_SIZE = 128;

/** Repeats the given action for each cell in the grid */
void onEachCell(BiConsumer<Integer, Integer> consumer) {
  for (int x = 0; x < width; x += GRID_SIZE) {
    for (int y = 0; y < height; y += GRID_SIZE) {
      consumer.accept(x, y);
    }
  }
}

/** Draws the given pixels in the cell at the given position */
void drawInCell(int x, int y, int[] pixels) {
  int finalX = x * GRID_SIZE;
  int finalY = y * GRID_SIZE;
  for (int i = 0; i < GRID_SIZE; i++) {
    for (int j = 0; j < GRID_SIZE; j++) {
      int index = i + j * GRID_SIZE;
      int colour = pixels[index];
      if (colour != 0) {
        set(finalX + i, finalY + j, colour);
      }
    }
  }
}

/** Draws the outline of each cell in the grid */
void debugGrid() {
  /*
  for (int x = 0; x < width; x += GRID_SIZE) {
    for (int y = 0; y < height; y += GRID_SIZE) {
      stroke(0);
      noFill();
      rect(x, y, GRID_SIZE, GRID_SIZE);
    }
  }*/
  onEachCell((x, y) -> {
    stroke(0);
    noFill();
    rect(x, y, GRID_SIZE, GRID_SIZE);
    fill(0);
    // text(x + ", " + y, x + 5, y + 15);
    int visibleX = x / GRID_SIZE;
    int visibleY = y / GRID_SIZE;
    text(visibleX + ", " + visibleY, x + 5, y + 15);
  });
}
