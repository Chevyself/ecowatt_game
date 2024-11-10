// Serial communication with arduino
import processing.serial.*;

Serial serial;
String inputBuffer = "";

void setupSerialCommunication() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port
  serial = new Serial(this, Serial.list()[0], 9600);
}

void processFullLine(String str) {
  println("Received: " + str);
}

void readInput(String input) {
  if (input.startsWith("~")) {
    if (inputBuffer.length() > 0) {
      println("Received incomplete message: " + inputBuffer);
    }
    inputBuffer = "";
  }
  inputBuffer += input;
  if (inputBuffer.endsWith("/~")) {
    processFullLine(inputBuffer);
    inputBuffer = "";
  }
}

// when we receive a message
void serialEvent(Serial serial) {
  String input = serial.readString();
  if (input != null) {
    readInput(input);
  }
}
