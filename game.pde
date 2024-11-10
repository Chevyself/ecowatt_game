
/*
Epic game to learn to use electricity efficiently!!
*/

Test test = new Test();

void setup() {
  // Basic
  fullScreen(P2D);
  // size(800, 800); // To test different resolutions

  // Framerate to 30
  frameRate(30);

  // Textures
  tiles = loadImage("tiles.png");
  tiles.loadPixels();
  reloadTextures();
  setupCamera();
}

void draw() {
  // Background
  background(255);

  // -- Game logic --
  grid.display();
  keybindsFrame();
  drawCharacter();

  test.hello();

  renderDebug();
}
