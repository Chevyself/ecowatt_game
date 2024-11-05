// Grid manager
int GRID_SIZE = 64; // Grid divides the screen 32x32

void onEachCell(BiConsumer<Integer, Integer> consumer) {
  for (int x = 0; x < width; x += GRID_SIZE) {
    for (int y = 0; y < height; y += GRID_SIZE) {
      consumer.accept(x, y);
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
  });
}
