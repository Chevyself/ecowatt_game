
// Bind f4 to "toggle" debug mode
void keyPressed() {
  if (key == '4') {
    debug = !debug;
  } else if (key == '5') {
    showTextures = !showTextures;
  } else if (key == 'w') {
     cameraY += CAMERA_SPEED;
  } else if (key == 'a') {
    cameraX += CAMERA_SPEED;
  } else if (key == 's') {
    cameraY -= CAMERA_SPEED;
  } else if (key == 'd') {
    cameraX -= CAMERA_SPEED;
  }
}
