
// Bind f4 to "toggle" debug mode
void keyPressed() {
  if (key == '4') {
    debug = !debug;
  }
}

// Bind f5 to "toggle" textures
void keyReleased() {
  if (key == '5') {
    showTextures = !showTextures;
  }
}
