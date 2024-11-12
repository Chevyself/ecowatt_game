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
  /** Whether is powered on */
  boolean isOn;

  // Transients
  PImage builtOffTexture;

  Furniture(int height, int width, int layout, String[][] offTextures, String[][] onTextures, int cost) {
    this.height = height;
    this.width = width;
    this.layout = layout;
    this.offTextures = offTextures;
    this.onTextures = onTextures;
    this.cost = cost;
    this.builtOffTexture = getBuiltOffTexture();
  }

  Furniture copy() {
    Furniture f = new Furniture(height, width, layout, offTextures, onTextures, cost);
    f.isOn = isOn;
    return f;
  }

  Furniture copyNextFacing() {
    Facing nextFacing = Facing.values()[(facing.ordinal() + 1) % Facing.values().length];
    Furniture f = new Furniture(height, width, layout, offTextures, onTextures, cost);
    f.isOn = isOn;
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