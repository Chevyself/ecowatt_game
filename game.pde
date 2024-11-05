
/*
Epic game to learn to use electricity efficiently!!
*/

boolean debug = true;

void setup() {
  // Basic
  fullScreen();
  // size(800, 800); // To test different resolutions

  // Framerate to 30
  frameRate(30);

  // Textures
  tiles = loadImage("tiles.png");
  tiles.loadPixels();
  reloadTextures();
}

void draw() {
  // Background
  background(255);

  // -- Game logic --
  drawInCell(0, 0, getTilePixels(0, 0));
  drawInCell(0, 1, getTilePixels(0, 0));

  // -- Space for debugging --
  if (debug) {
    debugGrid();
  }
}
