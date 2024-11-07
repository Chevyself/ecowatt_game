
// An infinite 2D grid system that moves around based on the camera's position

// Camera is declared in camera.pde
// vars:
//  cameraX
//  cameraY

int GRID_SIZE = 128;

class CellData {
  int[] texture = null;
}

class Grid {

  HashMap<PVector, CellData> cells = new HashMap<>();

  CellData getCellData(PVector cellKey) {
    return cells.get(cellKey);
  }

  CellData getOrCreateCellData(PVector cellKey) {
    if (!cells.containsKey(cellKey)) {
      cells.put(cellKey, new CellData());
    }
    return cells.get(cellKey);
  }

  CellData getOrCreateCellData(int cellX, int cellY) {
    // println("getOrCreateCellData for " + cellX + ", " + cellY);
    return getOrCreateCellData(new PVector(cellX, cellY));
  }

  void display() {
    // Calculate grid boundaries based on screen size
    float startX = cameraX - width/2;
    float startY = cameraY - height/2;
    float endX = cameraX + width/2;
    float endY = cameraY + height/2;

    // Align to grid
    float alignedStartX = floor(startX/GRID_SIZE) * GRID_SIZE;
    float alignedStartY = floor(startY/GRID_SIZE) * GRID_SIZE;

    // Draw cells
    for (float x = alignedStartX; x <= endX; x += GRID_SIZE) {
      for (float y = alignedStartY; y <= endY; y += GRID_SIZE) {
        // Get cell coordinates
        int cellX = floor(x/GRID_SIZE);
        int cellY = floor(y/GRID_SIZE);
        PVector cellKey = new PVector(cellX, cellY);

        // Get screen coordinates
        float screenX = x - cameraX + width/2;
        float screenY = y - cameraY + height/2;

        // If cell exists, draw its texture
        if (!cells.containsKey(cellKey)) {
          continue;
        }

        CellData cell = cells.get(cellKey);
        drawCellTexture(cell, screenX, screenY);
      }
    }
  }

  void drawCellTexture(CellData cell, float screenX, float screenY) {
    if (cell.texture == null || cell.texture.length <= 0) {
      return;
    }

    noStroke();
    for (int i = 0; i < GRID_SIZE; i++) {
      for (int j = 0; j < GRID_SIZE; j++) {
        int index = i + j * GRID_SIZE;
        if (index >= cell.texture.length) {
          break;
        }
        int pixel = cell.texture[index];
        if (pixel == 0) {
          continue;
        }
        fill(pixel);
        rect(screenX + i, screenY + j, 1, 1);
      }
    }
  }

  void debugDisplay() {
    // Calculate grid boundaries based on screen size
    float startX = cameraX - width/2;
    float startY = cameraY - height/2;
    float endX = cameraX + width/2;
    float endY = cameraY + height/2;

    // Align to grid
    float alignedStartX = floor(startX/GRID_SIZE) * GRID_SIZE;
    float alignedStartY = floor(startY/GRID_SIZE) * GRID_SIZE;

    stroke(0);
    strokeWeight(1);

    // Draw vertical lines
    for (float x = alignedStartX; x <= endX; x += GRID_SIZE) {
      float screenX = x - cameraX + width/2;
      line(screenX, 0, screenX, height);
    }

    // Draw horizontal lines
    for (float y = alignedStartY; y <= endY; y += GRID_SIZE) {
      float screenY = y - cameraY + height/2;
      line(0, screenY, width, screenY);
    }

    // Draw the coordinates of each cell
    for (float x = alignedStartX; x <= endX; x += GRID_SIZE) {
      for (float y = alignedStartY; y <= endY; y += GRID_SIZE) {
        float screenX = x - cameraX + width/2;
        float screenY = y - cameraY + height/2;
        fill(0);
        text(floor(x/GRID_SIZE) + ", " + floor(y/GRID_SIZE), screenX + 5, screenY + 15); }
    }
  }

  /**
   * Convert screen coordinates to world coordinates
   * @param screenX The x-coordinate on the screen
   * @param screenY The y-coordinate on the screen
   * @return A PVector containing the world coordinates
   */
  PVector screenToWorld(float screenX, float screenY) {
    float worldX = screenX - width/2 + cameraX;
    float worldY = screenY - height/2 + cameraY;
    return new PVector(worldX, worldY);
  }

  /**
   * Convert world coordinates to screen coordinates
   * @param worldX The x-coordinate in the world
   * @param worldY The y-coordinate in the world
   * @return A PVector containing the screen coordinates
   */
  PVector worldToScreen(float worldX, float worldY) {
    float screenX = worldX - cameraX + width/2;
    float screenY = worldY - cameraY + height/2;
    return new PVector(screenX, screenY);
  }
}

Grid grid = new Grid();