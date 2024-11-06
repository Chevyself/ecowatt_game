
// Grid manager
int GRID_SIZE = 128; // The size of cells in the grid X and Y in pixels

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
  int finalX = x * GRID_SIZE - cameraX;
  int finalY = y * GRID_SIZE - cameraY;
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

/** Draws the borders around the visible grid cells based on the current camera position */
void drawVisibleBorders() {
  // Calculate the starting positions based on the camera's current position
  int startX = (cameraX / GRID_SIZE) * GRID_SIZE;
  int startY = (cameraY / GRID_SIZE) * GRID_SIZE;

  // Calculate how many cells fit in the width and height based on GRID_SIZE
  int cols = (width + GRID_SIZE - 1) / GRID_SIZE;  // Number of visible columns (horizontal cells)
  int rows = (height + GRID_SIZE - 1) / GRID_SIZE; // Number of visible rows (vertical cells)

  // Loop through each visible cell and draw a border around it
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Calculate the final position of the cell in the screen coordinates
      int cellX = startX + i * GRID_SIZE - cameraX;
      int cellY = startY + j * GRID_SIZE - cameraY;

      // Draw the border around the visible cell
      noFill();
      stroke(255, 0, 0); // Red color for the borders (can be customized)
      strokeWeight(2); // Set border thickness
      rect(cellX, cellY, GRID_SIZE, GRID_SIZE); // Draw the rectangle for the cell border
    }
  }
}