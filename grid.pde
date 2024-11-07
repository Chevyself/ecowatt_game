// An infinite 2D grid system that moves around based on the camera's position

// Camera is declared in camera.pde
// vars:
//  cameraX
//  cameraY

int GRID_SIZE = 128;

class Grid {
  float cellSize = GRID_SIZE;  // Size of each grid cell
  color gridColor;      // Color of grid lines
  float opacity = 128;  // Grid line opacity

  Grid() {
    gridColor = color(200, 200, 200, opacity);
  }

  void display() {
    // Calculate grid boundaries based on screen size
    float startX = cameraX - width/2;
    float startY = cameraY - height/2;
    float endX = cameraX + width/2;
    float endY = cameraY + height/2;

    // Align to grid
    float alignedStartX = floor(startX/cellSize) * cellSize;
    float alignedStartY = floor(startY/cellSize) * cellSize;

    stroke(gridColor);
    strokeWeight(1);

    // Draw vertical lines
    for (float x = alignedStartX; x <= endX; x += cellSize) {
      float screenX = x - cameraX + width/2;
      line(screenX, 0, screenX, height);
    }

    // Draw horizontal lines
    for (float y = alignedStartY; y <= endY; y += cellSize) {
      float screenY = y - cameraY + height/2;
      line(0, screenY, width, screenY);
    }

    // Draw the coordinates of each cell
    for (float x = alignedStartX; x <= endX; x += cellSize) {
      for (float y = alignedStartY; y <= endY; y += cellSize) {
        float screenX = x - cameraX + width/2;
        float screenY = y - cameraY + height/2;
        fill(0);
        text(floor(x/cellSize) + ", " + floor(y/cellSize), screenX + 5, screenY + 15);
      }
    }
  }

  // Optional: Method to change grid cell size
  void setCellSize(float size) {
    cellSize = size;
  }

  // Optional: Method to change grid color
  void setColor(color c) {
    gridColor = c;
  }

  // Optional: Get world coordinates from screen coordinates
  PVector screenToWorld(float screenX, float screenY) {
    float worldX = screenX - width/2 + cameraX;
    float worldY = screenY - height/2 + cameraY;
    return new PVector(worldX, worldY);
  }

  // Optional: Get screen coordinates from world coordinates
  PVector worldToScreen(float worldX, float worldY) {
    float screenX = worldX - cameraX + width/2;
    float screenY = worldY - cameraY + height/2;
    return new PVector(screenX, screenY);
  }
}

Grid grid = new Grid();