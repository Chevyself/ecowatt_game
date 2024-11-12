import java.util.concurrent.atomic.AtomicInteger;

// Furniture to buy
ArrayList<Furniture> furnitureToBuy = new ArrayList<>();

// Actual furniture in the house
ArrayList<Furniture> furniture = new ArrayList<>();
int furnitureX = 0;
int furnitureY = 0;

Furniture placingFurniture;

// House controller
void setupHouse() {
  fillFurnitureToBuy();
  setupHouseLayout();
}

void drawHouse() {
  drawPlacingFurniture();
}

void drawPlacingFurniture() {
  if (placingFurniture == null) return;
  PImage texture = placingFurniture.builtOffTexture;
  if (texture == null) return;
  int x = (width / 2) + furnitureX;
  int y = (height / 2) + furnitureY;
  image(texture, x, y);
}

void resetPlacingFurniture() {
  placingFurniture = null;
  furnitureX = 0;
  furnitureY = 0;
}

void movePlacingFurniture(int x, int y) {
  furnitureX += x;
  furnitureY += y;
}

void attemptToPlaceFurniture() {
  if (placingFurniture == null) return;
  // Check if it is accepted in the grid
  int x = (furnitureX + playerX) / GRID_SIZE;
  int y = (furnitureY + playerY) / GRID_SIZE; // We now have the middle of the furniture in a cell
  // Check if the cells are free in the layout this is being placed
  for (int i = 0; i < placingFurniture.height; i++) {
    for (int j = 0; j < placingFurniture.width; j++) {
      CellData cellData = grid.getCellData(x + j, y + i);
      if (cellData != null && cellData.isObstacle && cellData.textureImages[placingFurniture.layout] != null) {
        println("Cannot place furniture here");
        return;
      }
    }
  }

  // Add to cell data
  for (int i = 0; i < placingFurniture.height; i++) {
    for (int j = 0; j < placingFurniture.width; j++) {
      CellData cellData = grid.getOrCreateCellData(x + j, y + i, new CellData());
      PImage texture = getTextureAsImage(placingFurniture.offTextures[i][j]);
      cellData.setTexture(texture , placingFurniture.layout);
      cellData.isObstacle = true;
    }
  }

  furniture.add(placingFurniture.copy());
  resetPlacingFurniture();
}

void setupHouseLayout() {
  // House layout is provided in the data/house file, it is a set of textures to set in the grid
  // load the house data
  String[] house = loadStrings(dataPath("house.txt"));
  // \n means go to the next y and commas separate textures

  AtomicInteger tX = new AtomicInteger(0);
  AtomicInteger tY = new AtomicInteger(0);

  // Setups the house in the grid
  for (String line : house) {
    String[] textures = line.split(",");
    for (String texture : textures) {
      // If ends with & it means the texture is an obstacle
      boolean obstacle = texture.endsWith("&");
      if (obstacle) {
        texture = texture.substring(0, texture.length() - 1);
      }
      if (texture.contains("*")) {
        String[] parts = texture.split("\\*");
        int times = Integer.parseInt(parts[1]);
        for (int i = 0; i < times; i++) {
          // drawInCell(tX.get(), tY.get(), parts[0]);
          CellData cellData = grid.getOrCreateCellData(tX.getAndIncrement(), tY.get(), new CellData());
          cellData.isObstacle = obstacle;
          cellData.setTexture(getTexture(parts[0]), 1);
        }
      } else {
        // drawInCell(tX.get(), tY.get(), texture);
        CellData cellData = grid.getOrCreateCellData(tX.get() - 1, tY.get(), new CellData());
        cellData.isObstacle = obstacle;
        cellData.setTexture(getTexture(texture), 1);
      }
    }
    tX.set(0);
    tY.incrementAndGet();
  }
}

void fillFurnitureToBuy() {
  Furniture tv = new Furniture(
    1,
    2,
    2,
    new String[][] {{"tv", "tvMirror"}},
    new String[][] {{"tvOn"}},
    1000
  );

  furnitureToBuy.add(tv);
}

void openShop() {
  if (modal != null && modal.showModal) {
    return;
  }
  modal = new Modal();
  modal.postRender = () -> {
    text("Shop", width / 2, height * 0.17);
  };
  modal.setupModal(() -> {
    addFurnitureToShop();
    modal.openModal();
  });
}

void addFurnitureToShop() {
  if (modal == null) {
    return;
  }
  println("Adding furniture to shop");
  AtomicInteger x = new AtomicInteger(-5);
  AtomicInteger y = new AtomicInteger(-2);
  furnitureToBuy.forEach(f -> {
    if (x.get() > 5) {
      x.set(-5);
      y.getAndAdd(2);
    }
    modal.addButton(x.getAndAdd(2), y.get(), "f.name", () -> {
      placingFurniture = f;
      modal.closeModal();
    });
  });
}