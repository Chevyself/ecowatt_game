
boolean debug = false;
boolean showTextures = false;

void renderDebug() {
  if (!debug) return;
  drawVisibleBorders();
  // Coords under the crosshair in the center of the screen
  fill(0);
  text("Camera: " + cameraX + ", " + cameraY, 5, 15);
  if (!showTextures) return;
  debugTextures();
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

/** Draws all the textures in the grid, also shows the name of the extra textures */
void debugTextures() {
  SimpleAtomic<Integer> tX = new SimpleAtomic<>(0);
  SimpleAtomic<Integer> tY = new SimpleAtomic<>(0);

  tilePixels.forEach((position, pixels) -> {
    drawInCell(tX.get(), tY.get(), pixels);
    tX.set(tX.get() + 1);
    if (tX.get() >= width / GRID_SIZE) {
      tX.set(0);
      tY.set(tY.get() + 1);
    }
  });
  extras.forEach((name, pixels) -> {
    drawInCell(tX.get(), tY.get(), pixels);
    // Add name of extra
    fill(255, 0, 0);
    text(name, tX.get() * GRID_SIZE + 5, tY.get() * GRID_SIZE + 15);
    tX.set(tX.get() + 1);
    if (tX.get() >= width / GRID_SIZE) {
      tX.set(0);
      tY.set(tY.get() + 1);
    }
  });
}
