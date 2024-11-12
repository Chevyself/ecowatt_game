// necessities go from 0-10
HashMap<String, Integer> necessities = new HashMap<>();

int currentFrame = 0;
int framesToMoney = 150; // 5 seconds
int framesToDecrease = 900; // 30 seconds

int temperature = 10;

void setupNecessities() {
  necessities.put("Comida", 10);
  necessities.put("Diversion", 10);
}

int getNecessity(String key) {
  if (key.equals("Temperatura")) {
    return temperature;
  }
  return necessities.get(key);
}

void increaseNecessity(String key) {
  if (necessities.containsKey(key)) {
    necessities.put(key, necessities.get(key) + 1);
    if (necessities.get(key) > 10) {
      necessities.put(key, 10);
    }
  }
  if (key.equals("Temperatura")) {
    temperature += 1;
    if (temperature > 10) {
      temperature = 10;
    }
  }
}

void decreaseNecessity(String key) {
  if (necessities.containsKey(key)) {
    necessities.put(key, necessities.get(key) - 1);
    if (necessities.get(key) < 0) {
      necessities.put(key, 0);
    }
  }
  if (key.equals("Temperatura")) {
    temperature -= 1;
    if (temperature < 0) {
      temperature = 0;
    }
  }
}

void checkMoney() {
  if (currentFrame % framesToMoney == 0) {
    // If all necessities are above 5, we get money
    if (necessities.values().stream().allMatch(value -> value >= 5) && temperature >= 5) {
      money += 10;
    }
  }
}

void renderNecessities() {
  if (currentFrame % framesToDecrease == 0) {
    // Use a random key that is not temperature
    String key = (String) necessities.keySet().toArray()[(int) random(0, 2)];
    necessities.put(key, necessities.get(key) - 1);
    if (necessities.get(key) < 0) {
      necessities.put(key, 0);
    }
  }

  AtomicInteger tY = new AtomicInteger(15);
  necessities.forEach((key, value) -> {
    textSize(12);
    text(key + ": " + value, 20, tY.getAndAdd(15));
  });
  text("Temperatura: " + temperature, 20, tY.getAndAdd(15));
  text("Dinerito: " + money, 20, tY.getAndAdd(15));

  textSize(32);
  currentFrame++;
  checkMoney();
}