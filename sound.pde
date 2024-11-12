/** Sound manager */
import ddf.minim.*;

Minim minim;
AudioPlayer loopModal; // Loop when modal is open
AudioPlayer loop; // Loop when playing
boolean soundEnabled = true;

void setupSound() {
  // Minim
  minim = new Minim(this);

  loop = minim.loadFile("sound/loop_playing.mp3", 2048);
  loopModal = minim.loadFile("sound/loop_modal.wav", 2048);
  loopModal.loop();
}

void soundOnOpenModal() {
  loop.pause();
  loopModal.loop();
}

void soundOnCloseModal() {
  loopModal.pause();
  loop.loop();
}

void quiet() {
  if (!soundEnabled) {
    return;
  }
  // Turn the volume to 0
  loop.setGain(-80);
  loopModal.setGain(-80);
  soundEnabled = false;
  println("QUIET");
}

void loud() {
  if (soundEnabled) {
    return;
  }
  loop.setGain(0);
  loopModal.setGain(0);
  soundEnabled = true;
}