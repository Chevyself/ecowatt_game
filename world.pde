import java.util.concurrent.atomic.AtomicBoolean;

// An infinite 2D grid system that moves around based on the camera's position

// Camera is declared in camera.pde
// vars:
//  playerX
//  playerY

Grid<CellData> grid;

/** Max amount of layers per cell data in the grid */
int MAX_LAYERS = 3;

class CellData implements ICellData {
  // CellData may have layers of textures
  // Layer 0 being reserved for walls, grass or any base
  // Layer 1 being reserved for objects that must be exactly above the floor or base. ie trees, furniture
  // Layer 2 being reserved for objects that must be exactly above the objects in layer 1. ie. a bird on top of a tree or
  // a computer on top of a desk
  // PImage[] textureImages = new PImage[MAX_LAYERS];
  PImage[][] textureImages = new PImage[MAX_LAYERS][]; // To support animations
  /** Whether this cell blocks the player's movement */
  boolean isObstacle = false;
  int maxAnimationFrameHold = 5;
  int currentAnimationFrame = 0;
  int currentAnimationFrameHold = 0;

  void setTexture(int[] texture, int layer) {
    // this.textureImages[layer] = new PImage[1]{pixelsToImage(texture)};
    setTexture(pixelsToImage(texture), layer);
  }

  void setTexture(PImage texture, int layer) {
    this.textureImages[layer] = new PImage[]{texture};
  }

  void setAnimation(int[][] textures, int layer) {
    this.textureImages[layer] = new PImage[textures.length];
    for (int i = 0; i < textures.length; i++) {
      this.textureImages[layer][i] = pixelsToImage(textures[i]);
    }
  }

  void setAnimation(PImage[] textures, int layer) {
    this.textureImages[layer] = textures;
  }

  @Override
  boolean isObstacle() {
    return isObstacle;
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
    // drawTextureInCell(cell, screenX, screenY, cell.textureImages[i]);
    if (cell.textureImages[i] != null) {
      if (cell.textureImages[i].length > 1) {
        if (cell.currentAnimationFrameHold == 0) {
          cell.currentAnimationFrame = (cell.currentAnimationFrame + 1) % cell.textureImages[i].length;
          cell.currentAnimationFrameHold = cell.maxAnimationFrameHold;
        } else {
          cell.currentAnimationFrameHold--;
        }
        drawTextureInCell(cell, screenX, screenY, cell.textureImages[i][cell.currentAnimationFrame]);
      } else {
        drawTextureInCell(cell, screenX, screenY, cell.textureImages[i][0]);
      }
    }
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

/** Checks if the player hitbox will collide with any obstacle in the grid */
boolean checkPlayerCollision(int nextPlayerX, int nextPlayerY) {
  return grid.isValidPositionWithDistance(nextPlayerX, nextPlayerY, GRID_SIZE / 2, 1);
}
