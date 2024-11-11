import java.util.concurrent.atomic.AtomicInteger;

boolean debug = false;
boolean showTextures = false;
boolean texturesShow = false;

void renderDebug() {
  if (!debug) return;
  //grid.debugDisplay();
  fill(0);
  text("Camera: " + cameraX + ", " + cameraY, 5, 15);
  text("FPS: " + frameRate, 5, 30);
  if (!showTextures) return;
  if (!texturesShow) {
    texturesShow = true;
    debugTextures();
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
  }
  onEachCell((x, y) -> {
    stroke(0);
    noFill();
    rect(x, y, GRID_SIZE, GRID_SIZE);
    fill(0);
    // text(x + ", " + y, x + 5, y + 15);
    int visibleX = x / GRID_SIZE;
    int visibleY = y / GRID_SIZE;
    text(visibleX + ", " + visibleY, x + 5, y + 15);
  });*/
}

/** Draws all the textures in the grid, also shows the name of the extra textures */
void debugTextures() {
  AtomicInteger tX = new AtomicInteger(0);
  AtomicInteger tY = new AtomicInteger(0);
  tilePixels.forEach((position, pixels) -> {
    // drawInCell(tX.get(), tY.get(), pixels);
    grid.getOrCreateCellData(tX.getAndIncrement(), tY.get(), new CellData()).setTexture(pixels);
    if (tX.get() >= width / GRID_SIZE) {
      tX.set(0);
      //tY.set(tY.get() + 1);
      tY.incrementAndGet();
    }
  });
  extras.forEach((name, pixels) -> {
    grid.getOrCreateCellData(tX.get(), tY.get(), new CellData()).setTexture(pixels);
    fill(255, 0, 0);
    text(name, tX.getAndIncrement() * GRID_SIZE + 5, tY.get() * GRID_SIZE + 15);
    if (tX.get() >= width / GRID_SIZE) {
      tX.set(0);
      tY.incrementAndGet();
    }
  });
}