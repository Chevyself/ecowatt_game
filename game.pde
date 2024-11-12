
/*
Epic game to learn to use electricity efficiently!!
*/

void setup() {
  // Basic
  fullScreen(P2D);
  // size(800, 800); // To test different resolutions

  // Framerate to 30
  frameRate(30);

  // Setup serial
  setupSerialCommunication();

  // World
  setupGrid();

  // Textures
  tiles = loadImage("tiles.png");
  tiles.loadPixels();
  reloadTextures();
  setupCamera();
  setupHouse();
}

void draw() {
  // Background
  background(255);

  // -- Game logic --
  renderGrid();
  keybindsFrame();
  drawCharacter();

  renderDebug();
}
