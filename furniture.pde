enum Facing {
  /** Facing the camera */
  FACING,
  /** Right side facing the camera */
  RIGHT,
  /** Left facing the camera */
  LEFT,
  // TODO behind, no time
}

// Furniture class, it is a cuboid as it may have a min and max positions
// in the grid, for instance a table is a 2x2, a tv is a 2x1 same as a computer
class Furniture {
  /** Name of this furniture */
  String name;
  /** Height of the furniture */
  int height;
  /** Width of the furniture */
  int width;
  /** In which layout of the grid is this furniture */
  int layout;
  /** Off textures */
  String[][] offTextures;
  /** On textures */
  String[][] onTextures;
  /** Where is this furniture facing */
  Facing facing = Facing.FACING;
  /** How much does this furniture cost */
  int cost;
  /** How many kwH will this consumer per tick */
  float consumption;
  /** Whether is powered on */
  boolean isOn;
  /** X position in the grid */
  int x;
  /** Y position in the grid */
  int y;
  /** How will this furniture affect the necessities */
  Runnable changeNecessitiesTick = () -> {};

  // Transients
  PImage builtOffTexture;

  Furniture(String name, int height, int width, int layout, String[][] offTextures, String[][] onTextures, int cost, float consumption) {
    this.name = name;
    this.height = height;
    this.width = width;
    this.layout = layout;
    this.offTextures = offTextures;
    this.onTextures = onTextures;
    this.cost = cost;
    this.builtOffTexture = getBuiltOffTexture();
    this.consumption = consumption;
  }

  Furniture copy() {
    Furniture f = new Furniture(name, height, width, layout, offTextures, onTextures, cost, consumption);
    f.isOn = isOn;
    f.changeNecessitiesTick = changeNecessitiesTick;
    return f;
  }

  Furniture copyNextFacing() {
    Facing nextFacing = Facing.values()[(facing.ordinal() + 1) % Facing.values().length];
    Furniture f = new Furniture(name, height, width, layout, offTextures, onTextures, cost, consumption);
    f.isOn = isOn;
    f.changeNecessitiesTick = changeNecessitiesTick;
    return f;
  }

  PImage getBuiltOffTexture() {
    PImage[][] textures = new PImage[offTextures.length][];
    for (int i = 0; i < offTextures.length; i++) {
      textures[i] = new PImage[offTextures[i].length];
      for (int j = 0; j < offTextures[i].length; j++) {
        textures[i][j] = getTextureAsImage(offTextures[i][j]);
      }
    }
    // Construct a single texture
    return buildTexture(textures, height, width);
  }
}