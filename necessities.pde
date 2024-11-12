// necessities go from 0-10
HashMap<String, Integer> necessities = new HashMap<>();

void setupNecessities() {
  necessities.put("food", 5);
  necessities.put("fun", 5);
  necessities.put("hygiene", 10);
  necessities.put("temperature", 10); // The only one that does not degrade by time but by environment
}

void renderNecessities() {
  necessities.forEach((key, value) -> {
    text(key + ": " + value, 10, 10);
  });
}