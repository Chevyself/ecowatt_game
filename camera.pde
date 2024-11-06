
int CAMERA_SPEED = 12;

// Basically, the camera, is how far we've gone from
// the origin
int cameraX = 0;
int cameraY = 0;

// draw on the center of the screen
void drawCrossHair() {
  int x = width / 2;
  int y = height / 2;
  stroke(255, 0, 0);
  line(x - 10, y, x + 10, y);
  line(x, y - 10, x, y + 10);
}