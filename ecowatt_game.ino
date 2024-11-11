// Buttons
const int numberOfButtons = 4;
const int buttonPins[4] = {50, 51, 52, 53};

// Analog stick
const int xAnalogPin = A10;
const int yAnalogPin = A9;
const int analogButtonPin = 43;

// Proximity sensor
const int echoPin = 46;
const int trigPin = 47;
const int proximityCheckDelay = 1000;  // Check every 1 second
const unsigned long proximityTimeout = 25000; // Maximum microseconds 
long lastProximityCheck = 0;
int distance = 0;

void setup() {
  Serial.begin(9600);
  
  // Buttons 
  for (int i = 0; i < numberOfButtons; i++) {
    pinMode(buttonPins[i], INPUT);  
  }

  // Analog button pin
  pinMode(analogButtonPin, INPUT_PULLUP);
  
  // Proximity sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  unsigned long millisNow = millis();  
  
  // Read buttons first 
  String out = "~";
  for (int i = 0; i < numberOfButtons; i++) {
    out += i;
    out += ":";
    out += digitalRead(buttonPins[i]);  
    if (i != numberOfButtons - 1) out += ",";
  }
  out += ";";
  
  // Analog stick
  out += analogRead(xAnalogPin);
  out += ",";
  out += analogRead(yAnalogPin);
  out += ",";
  out += !digitalRead(analogButtonPin);
  out += ";";

  // Only check proximity sensor when it's time
  if (lastProximityCheck < millisNow) {
    // Trigger proximity sensor
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    
    // Read proximity sensor with timeout
    long duration = pulseIn(echoPin, HIGH, proximityTimeout);
    
    // Only update distance if we got a valid reading
    if (duration > 0) {
      distance = duration * 0.034 / 2;
    }
    
    lastProximityCheck = millisNow + proximityCheckDelay;
  }
  
  out += distance;
  out += "/~";
  Serial.println(out);
  
  //delay(500);
  //delay(10);
}
