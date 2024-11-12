import java.util.concurrent.atomic.AtomicInteger;

int MAX_TURNED_ON_DISTANCE = 200;
int MAX_DISTANCE_TO_TURN_ON = 180;

// Furniture to buy
ArrayList<Furniture> furnitureToBuy = new ArrayList<>();

// Actual furniture in the house
ArrayList<Furniture> furniture = new ArrayList<>();
int furnitureX = 0;
int furnitureY = 0;

Furniture placingFurniture;

float kwHConsumed = 0;
float kmHConsumedInEfficiently = 0;
boolean isConsumingInEfficiently = false;
int tickToChangeNecessities = 900; // 10 seconds

// House controller
void setupHouse() {
  fillFurnitureToBuy();
  setupHouseLayout();
}

/** Attempts to turn on furniture near the player */
void turnOnFurniture() {
  furniture.forEach(f -> {
    if (!f.isOn && dist(playerX, playerY, f.x * GRID_SIZE, f.y * GRID_SIZE) < MAX_DISTANCE_TO_TURN_ON) {
      f.isOn = true;
      setOnTexture(f);
    }
  });
}

void turnOffFurniture() {
  furniture.forEach(f -> {
    if (f.isOn && dist(playerX, playerY, f.x * GRID_SIZE, f.y * GRID_SIZE) < MAX_DISTANCE_TO_TURN_ON) {
      f.isOn = false;
      setOffTexture(f);
    }
  });
}

void drawHouse() {
  drawPlacingFurniture();
  // Increase per furniture
  furniture.forEach(f -> {
    if (f.isOn) {
      kwHConsumed += f.consumption;
      if (dist(playerX, playerY, f.x * GRID_SIZE, f.y * GRID_SIZE) > MAX_TURNED_ON_DISTANCE) {
        isConsumingInEfficiently = true;
        kmHConsumedInEfficiently += f.consumption;
      } else {
        if (currentFrame % tickToChangeNecessities == 0) {
          println("Changing necessities!");
          f.changeNecessitiesTick.run();
        }
      }
    }
  });
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
  if (placingFurniture.cost > money) {
    playNoMoneySound();
    return;
  }
  money -= placingFurniture.cost;
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

  Furniture copy = placingFurniture.copy();
  copy.x = x;
  copy.y = y;
  setOffTexture(copy);

  furniture.add(copy);
  resetPlacingFurniture();
}

private void setOffTexture(Furniture f) {
  for (int i = 0; i < f.height; i++) {
    for (int j = 0; j < f.width; j++) {
      CellData cellData = grid.getCellData(f.x + j, f.y + i);
      if (cellData != null) {
        cellData.setTexture(getTextureAsImage(f.offTextures[i][j]), f.layout);
      }
    }
  }
}

private void setOnTexture(Furniture f) {
  for (int i = 0; i < f.height; i++) {
    for (int j = 0; j < f.width; j++) {
      CellData cellData = grid.getCellData(f.x + j, f.y + i);
      if (cellData != null) {
        // cellData.setTexture(getTextureAsImage(f.onTextures[i][j]), f.layout);
        Animation animation = animations.get(f.onTextures[i][j]);
        if (animation != null) {
          cellData.setAnimation(animation.frames, f.layout);
        } else {
          cellData.setTexture(getTextureAsImage(f.onTextures[i][j]), f.layout);
        }
      }
    }
  }
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
  Furniture ac = new Furniture(
    "Aire acondicionado",
    1,
    2,
    2,
    new String[][] {{"ac", "acMirror"}},
    new String[][] {{"acOn", "acOnMirror"}},
    1000,
    0.8
  );
  ac.changeNecessitiesTick = () -> {
    decreaseNecessity("Comida");
    increaseNecessity("Temperatura");
    if (getNecessity("Temperatura") == 10) {
      isConsumingInEfficiently = true;
    }
  };
  Furniture bulb = new Furniture(
    "Bombilla",
    1,
    1,
    2,
    new String[][] {{"bulb"}},
    new String[][] {{"bulbOn"}},
    100,
    0.1
  );
  bulb.changeNecessitiesTick = () -> {
    increaseNecessity("Temperatura");
    decreaseNecessity("Comida");
    if (getNecessity("Temperatura") == 10) {
      isConsumingInEfficiently = true;
    }
  };
  Furniture fridge = new Furniture(
    "Nevera",
    2,
    1,
    2,
    new String[][] {{"fridge"},
                    {"fridgeLower"}},
    new String[][] {{"fridgeOn"},
                    {"fridgeLowerOn"}},
    1000,
    0.6
  );
  fridge.changeNecessitiesTick = () -> {
    increaseNecessity("Comida");
    if (getNecessity("Comida") == 10) {
      isConsumingInEfficiently = true;
    }
  };
  Furniture mike = new Furniture(
    "Microondas",
    1,
    1,
    2,
    new String[][] {{"mike"}},
    new String[][] {{"mikeOn"}},
    100,
    0.2
  );
  mike.changeNecessitiesTick = () -> {
    increaseNecessity("Comida");
    decreaseNecessity("Diversion");
    decreaseNecessity("Temperatura");
    if (getNecessity("Comida") == 10) {
      isConsumingInEfficiently = true;
    }
  };
  Furniture pc = new Furniture(
    "Computadora",
    1,
    2,
    2,
    new String[][] {{"pc", "pc2"}},
    new String[][] {{"pcOn", "pc2On"}},
    1000,
    0.5
  );
  pc.changeNecessitiesTick = () -> {
    increaseNecessity("Diversion");
    decreaseNecessity("Comida");
    if (getNecessity("Diversion") == 10) {
      isConsumingInEfficiently = true;
    }
  };
  Furniture tv = new Furniture(
    "Televisor",
    1,
    2,
    2,
    new String[][] {{"tv", "tvMirror"}},
    new String[][] {{"tvOn", "tvOnMirror"}},
    1000,
    0.4
  );
  tv.changeNecessitiesTick = () -> {
    increaseNecessity("Diversion");
    if (getNecessity("Diversion") == 10) {
      isConsumingInEfficiently = true;
    }
  };

  furnitureToBuy.add(ac);
  furnitureToBuy.add(bulb);
  furnitureToBuy.add(fridge);
  furnitureToBuy.add(mike);
  furnitureToBuy.add(pc);
  furnitureToBuy.add(tv);
}

void openShop() {
  if (modal != null && modal.showModal) {
    return;
  }
  modal = new Modal();
  modal.postRender = () -> {
    text("Tienda", width / 2, height * 0.17);
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
    modal.addButton(x.getAndAdd(2), y.get(), f.name, () -> {
      placingFurniture = f;
      modal.closeModal();
    });
  });
}