
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
}

void draw() {
  // Background
  background(255);

  // -- Game logic --

  // -- Space for debugging --
  if (debug) {
    debugGrid();
  }
}
