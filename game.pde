/*
Epic game to learn to use electricity efficiently!!
*/
enum GameState {
  STARTING, // First modal! Waiting for any key to start!
  PAUSED, // Game is paused
  PLAYING, // Game is playing
  MODAL, // Player is currently in a modal
  END // Game is over
}

// The max distance before we keep the camera black (off).
// As this game is about saving energy, if there's no player nearby
// We are going to turn off the screen
int MAX_DISTANCE = 25; //cm

void setup() {
  // Basic
  fullScreen(P2D);
  // Framerate to 30
  frameRate(30);

  // Setup serial
  setupSerialCommunication();

  // Setup sound
  setupSound();

  // Textures
  reloadTextures();

  // World
  setupGrid();

  // Entities
  setupPlayer();
  setupHouse();
}

void draw() {
  // Background
  background(0);

  if (currentDistance > MAX_DISTANCE) {
    quiet();
    return;
  } else {
    loud();
  }

  keybindsFrame();
  // Modals have the most priority
  if (modal == null || !modal.showModal) {
    renderGrid();
    drawCharacter();
    renderNecessities();
    drawHouse();
  } else {
    modal.render();
  }
  renderDebug();
}