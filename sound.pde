/** Sound manager */
import ddf.minim.*;

Minim minim;
AudioPlayer loopModal; // Loop when modal is open
AudioPlayer loop; // Loop when playing
AudioPlayer click; // Click sound
AudioPlayer noMoney; // No money sound
boolean soundEnabled = true;

void setupSound() {
  // Minim
  minim = new Minim(this);

  loop = minim.loadFile("sound/loop_playing.mp3", 2048);
  loopModal = minim.loadFile("sound/loop_modal.wav", 2048);
  click = minim.loadFile("sound/blip.wav", 2048);
  noMoney = minim.loadFile("sound/no_money.wav", 2048);

  loop.loop();
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

void playClickSound() {
  if (!soundEnabled) {
    return;
  }
  click.rewind();
  click.play();
}

void playNoMoneySound() {
  if (!soundEnabled) {
    return;
  }
  noMoney.rewind();
  noMoney.play();
}