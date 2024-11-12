import java.util.concurrent.atomic.AtomicInteger;

// House controller
void setupHouse() {
  // House is provided in the data/house file, it is a set of textures to set in the grid
  // load the house data
  String[] house = loadStrings(dataPath("house.txt"));
  // \n means go to the next y and commans separate textures

  AtomicInteger tX = new AtomicInteger(0);
  AtomicInteger tY = new AtomicInteger(0);

  /*
  for (String line : house) {
    String[] textures = line.split(",");
    for (String texture : textures) {
      // drawInCell(tX.get(), tY.get(), texture);
      grid.getOrCreateCellData(tX.getAndIncrement(), tY.get(), new CellData()).setTexture(getTexture(texture));
    }
    tX.set(0);
    tY.incrementAndGet();
  }*/
  // Lets change the code above, now if the texture name is followed by *number, it will repeat the texture that number of times
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
          cellData.setTexture(getTexture(parts[0]), 0);
        }
      } else {
        // drawInCell(tX.get(), tY.get(), texture);
        CellData cellData = grid.getOrCreateCellData(tX.get() - 1, tY.get(), new CellData());
        cellData.isObstacle = obstacle;
        cellData.setTexture(getTexture(texture), 0);
      }
    }
    tX.set(0);
    tY.incrementAndGet();
  }
}