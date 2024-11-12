import java.util.concurrent.atomic.AtomicBoolean;

// An infinite 2D grid system that moves around based on the camera's position

// Camera is declared in camera.pde
// vars:
//  playerX
//  playerY

Grid<CellData> grid;

/** Max amount of layers per cell data in the grid */
int MAX_LAYERS = 3;

class CellData {
  // CellData may have layers of textures
  // Layer 0 being reserved for walls, grass or any base
  // Layer 1 being reserved for objects that must be exactly above the floor or base. ie trees, furniture
  // Layer 2 being reserved for objects that must be exactly above the objects in layer 1. ie. a bird on top of a tree or
  // a computer on top of a desk
  PImage[] textureImages = new PImage[MAX_LAYERS];
  /** Whether this cell blocks the player's movement */
  boolean isObstacle = false;

  void setTexture(int[] texture, int layer) {
    this.textureImages[layer] = pixelsToImage(texture);
  }

  void setTexture(PImage texture, int layer) {
    this.textureImages[layer] = texture;
  }
}

void setupGrid() {
  grid = new Grid<CellData>(GRID_SIZE);

  // Fill with something
  growGrass();
}

/** Fills a big area with grass */
void growGrass() {
  int[] grassTexture = getTexture("grass");
  println("grassTexture: " + grassTexture.length);
  for (int i = -100; i < 100; i++) {
    for (int j = -100; j < 100; j++) {
      grid.getOrCreateCellData(i, j, new CellData()).setTexture(grassTexture, 0);
    }
  }
}

void renderGrid() {
  // Render each layer in order
  float startX = playerX - width/2;
  float startY = playerY - height/2;
  float endX = playerX + width/2;
  float endY = playerY + height/2;
  for (int layer = 0; layer < MAX_LAYERS; layer++) {
    AtomicBoolean drawCharacter = new AtomicBoolean(true);
    grid.loopThrough(
      playerX,
      playerY,
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
}

void drawCellTexture(CellData cell, float screenX, float screenY) {
  for (int i = 0; i < cell.textureImages.length; i++) {
    drawTextureInCell(cell, screenX, screenY, cell.textureImages[i]);
  }
}

void drawTextureInCell(CellData cell, float screenX, float screenY, PImage texture) {
  if (texture == null) {
    return;
  }
  noStroke();
  image(texture, screenX, screenY);
}

void debugGrid() {
  // Calculate grid boundaries based on screen size
  float startX = playerX - width/2;
  float startY = playerY - height/2;
  float endX = playerX + width/2;
  float endY = playerY + height/2;

  // Align to grid
  float alignedStartX = floor(startX/GRID_SIZE) * GRID_SIZE;
  float alignedStartY = floor(startY/GRID_SIZE) * GRID_SIZE;

  stroke(0);
  strokeWeight(1);

  // Draw vertical lines
  for (float x = alignedStartX; x <= endX; x += GRID_SIZE) {
    float screenX = x - playerX + width/2;
    line(screenX, 0, screenX, height);
  }

  // Draw horizontal lines
  for (float y = alignedStartY; y <= endY; y += GRID_SIZE) {
    float screenY = y - playerY + height/2;
    line(0, screenY, width, screenY);
  }

  // Draw the coordinates of each cell
  for (float x = alignedStartX; x <= endX; x += GRID_SIZE) {
    for (float y = alignedStartY; y <= endY; y += GRID_SIZE) {
      float screenX = x - playerX + width/2;
      float screenY = y - playerY + height/2;
      fill(0);
      text(floor(x/GRID_SIZE) + ", " + floor(y/GRID_SIZE), screenX + 5, screenY + 15); }
  }
}

/** Checks if the player hitbox will not collide with any obstacle in the grid */
boolean checkPlayerCollision(int nextPlayerX, int nextPlayerY) {
  // Calculate the hitbox boundaries based on the player's position
  int playerMinX = nextPlayerX - GRID_SIZE / 2;
  int playerMaxX = nextPlayerX + GRID_SIZE / 2;
  int playerMinY = nextPlayerY - GRID_SIZE / 2;
  int playerMaxY = nextPlayerY + GRID_SIZE / 2;

  // Loop through all grid positions the player might occupy
  for (int x = playerMinX; x <= playerMaxX; x += GRID_SIZE) {
    for (int y = playerMinY; y <= playerMaxY; y += GRID_SIZE) {
      // Get the grid coordinates by dividing by GRID_SIZE (to map to grid indices)
      int gridX = x / GRID_SIZE;
      int gridY = y / GRID_SIZE;

      // Ensure the grid coordinates are valid
      CellData cell = grid.getCellData(gridX, gridY);
      if (cell != null && cell.isObstacle) {
        return false; // Collision detected
      }
    }
  }
  return true; // No collision
}

/**
  * Checks the amount of distance a player can move based on collisions
  * If there's no collision changes will be returned as is
  * If there's a collision, the changes will be adjusted to the maximum possible distance or
  * 0 if the player can't move at all
  * Annotated method works but it does not return the changes
int[] checkPlayerCollision(int changeX, int changeY) {
  // Calculate the hitbox boundaries based on the player's position
  int playerMinX = playerX - GRID_SIZE / 2;
  int playerMaxX = playerX + GRID_SIZE / 2;
  int playerMinY = playerY - GRID_SIZE / 2;
  int playerMaxY = playerY + GRID_SIZE / 2;

  // Loop through all grid positions the player might occupy
  for (int x = playerMinX; x <= playerMaxX; x += GRID_SIZE) {
    for (int y = playerMinY; y <= playerMaxY; y += GRID_SIZE) {
      // Get the grid coordinates by dividing by GRID_SIZE (to map to grid indices)
      int gridX = x / GRID_SIZE;
      int gridY = y / GRID_SIZE;

      // Ensure the grid coordinates are valid
      CellData cell = grid.getCellData(gridX, gridY);
      if (cell != null && cell.isObstacle) {
        // Collision detected
        // Calculate the maximum distance the player can move
        // Distance until the player hits the obstacle
        int distanceX = 0;
        int distanceY = 0;
        if (changeX > 0) {
          distanceX = x - playerMaxX;
        } else if (changeX < 0) {
          distanceX = playerMinX - x - GRID_SIZE;
        }
        if (changeY > 0) {
          distanceY = y - playerMaxY;
        } else if (changeY < 0) {
          distanceY = playerMinY - y - GRID_SIZE;
        }
        return new int[] {distanceX, distanceY};
      }
    }
  }
  return new int[] {changeX, changeY};
}
*/

