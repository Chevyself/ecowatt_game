
// An infinite 2D grid system that moves around based on the camera's position

// Camera is declared in camera.pde
// vars:
//  cameraX
//  cameraY

Grid<CellData> grid;

class CellData {
  int[] texture;
  PImage textureImage;

  void setTexture(int[] texture) {
    this.texture = texture;
    this.textureImage = createImage(GRID_SIZE, GRID_SIZE, RGB);
    this.textureImage.loadPixels();
    for (int i = 0; i < texture.length; i++) {
      this.textureImage.pixels[i] = texture[i];
    }
    this.textureImage.updatePixels();
  }
}

void setupGrid() {
  grid = new Grid<CellData>(GRID_SIZE);
  for (int i = -100; i < 100; i++) {
    for (int j = -100; j < 100; j++) {
      grid.getOrCreateCellData(i, j, new CellData()).setTexture(grass());
    }
  }
}

void renderGrid() {
  float startX = cameraX - width/2;
  float startY = cameraY - height/2;
  float endX = cameraX + width/2;
  float endY = cameraY + height/2;
  grid.loopThrough(
    cameraX,
    cameraY,
    width,
    height,
    startX,
    startY,
    endX,
    endY,
    false,
    (x, y, cell) -> {
      drawCellTexture(cell, x, y);
    });
}

void drawCellTexture(CellData cell, float screenX, float screenY) {
    if (cell.texture == null || cell.texture.length <= 0) {
        return;
    }

    noStroke();

    // Create a single PImage object to hold the texture
    //PImage cellTexture = createImage(grid.size(), grid.size(), RGB);
//
    //// Set the pixel data for the texture
    //cellTexture.loadPixels();
    //for (int i = 0; i < cell.texture.length; i++) {
    //    cellTexture.pixels[i] = cell.texture[i];
    //}
    //cellTexture.updatePixels();

    // Draw the texture to the screen
    //image(cellTexture, screenX, screenY);
    image(cell.textureImage, screenX, screenY);
}
