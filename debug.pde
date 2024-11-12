import java.util.concurrent.atomic.AtomicInteger;

boolean debug = false;
boolean showTextures = false;
boolean texturesShow = false;

void renderDebug() {
  if (!debug) return;
  debugGrid();
  fill(0);
  text("Camera: " + cameraX + ", " + cameraY, 5, 15);
  text("FPS: " + frameRate, 5, 30);
  text("Grid: " + (cameraX / GRID_SIZE) + ", " + (cameraY / GRID_SIZE), 5, 45);
  if (!showTextures) return;
  if (!texturesShow) {
    texturesShow = true;
    debugTextures();
  }
}

/** Draws all the textures in the grid, also shows the name of the extra textures */
void debugTextures() {
  AtomicInteger tX = new AtomicInteger(0);
  AtomicInteger tY = new AtomicInteger(0);
  textures.forEach((key, pixels) -> {
    // drawInCell(tX.get(), tY.get(), pixels);
    grid.getOrCreateCellData(tX.getAndIncrement(), tY.get(), new CellData()).setTexture(pixels, 0);
    if (tX.get() >= width / GRID_SIZE) {
      tX.set(0);
      //tY.set(tY.get() + 1);
      tY.incrementAndGet();
    }
  });
}