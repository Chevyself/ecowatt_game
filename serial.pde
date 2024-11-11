// Serial communication with arduino
import processing.serial.*;

Serial serial;
String inputBuffer = "";

// Button states stored to not repeat key presses
HashMap<Character, Integer> buttonsStates = new HashMap<>();

// Mappings
HashMap<Integer, Character> buttonMapping = new HashMap<>();
// Analog button mapping
char analogButton = 'b';

// Distance
int currentDistance = Integer.MAX_VALUE;

void setupSerialCommunication() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port
  serial = new Serial(this, Serial.list()[0], 9600);

  // Init mappings
  buttonMapping.put(0, 'z');
  buttonMapping.put(1, 'x');
  buttonMapping.put(2, 'c');
  buttonMapping.put(3, 'v');
}

void processFullLBuffer(String str) {
  // Example message of a complete healthy buffer:
  // ~0:0,1:0,2:0,3:0;501,515,0;141/~
  // Breakdown:
  // ~ start
  // <button index>:<button state> separated by commas.
  // State 0 means the button is not pressed, 1 means it is pressed.
  // ; separator
  // <analog x>,<analog y>,<analog button state>
  // ; separator
  // <distance> (in cm)
  // /~ end

  str = str.substring(1, str.length() - 2);

  String[] parts = split(str, ';');

  // Button states
  String[] buttonStates = split(parts[0], ',');
  for (String buttonState : buttonStates) {
    String[] buttonStateParts = split(buttonState, ':');
    int buttonIndex = int(buttonStateParts[0]);
    char button = buttonMapping.get(buttonIndex);
    int state = int(buttonStateParts[1]);
    int oldState = buttonsStates.getOrDefault(button, 0);
    if (oldState == state) {
      continue;
    }
    println("Button " + button + " state: " + state);
    if (state == 1) {
      keyPressed(button);
    } else {
      keyReleased(button);
    }
  }

  // Analog states
  // max in analog x is 1023, min is 0
  // max in analog y is 1023, min is 0
  // We are going to map it to -MAX_CAMERA_SPEED to MAX_CAMERA_SPEED
  String[] analogStates = split(parts[1], ',');
  int analogX = int(analogStates[0]);
  int analogY = int(analogStates[1]);
  int analogButtonState = int(analogStates[2]);

  int xMapped = (int) map(analogX, 0, 1023, -MAX_CAMERA_SPEED, MAX_CAMERA_SPEED);
  int yMapped = (int) map(analogY, 0, 1023, -MAX_CAMERA_SPEED, MAX_CAMERA_SPEED);
  // Basically x is up and down so > 0 is up else down
  if (xMapped == 0) {
    keysPressed.remove('w');
    keysPressed.remove('s');
    checkIsMoving();
  } else {
    if (xMapped > 0) {
       keysPressed.put('w', xMapped);
    } else {
      keysPressed.put('s', -xMapped);
    }
  }
  // For y < 0 is left else right
  if (yMapped == 0) {
    keysPressed.remove('a');
    keysPressed.remove('d');
    checkIsMoving();
  } else {
    if (yMapped < 0) {
      keysPressed.put('a', -yMapped);
    } else {
      keysPressed.put('d', yMapped);
    }
  }

  // Stick button press
  if (analogButtonState == 1) {
    keyPressed(analogButton);
  } else {
    keyReleased(analogButton);
  }

  // Distance
  currentDistance = int(parts[2]);
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
    processFullLBuffer(inputBuffer);
    inputBuffer = "";
  }
}

// when we receive a message
void serialEvent(Serial serial) {
  String input = serial.readStringUntil('\n');
  if (input != null) {
    readInput(input.trim());
  }
}
