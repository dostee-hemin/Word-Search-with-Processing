class Tile {
  PVector location;
  char letter = ' ';

  boolean isSelected;

  float normalSize;
  float currentSize;
  float largeSize;
  boolean isPulsing;
  boolean isRising = true;

  Tile(float x, float y) {
    location = new PVector(x, y);
    normalSize = tileSize*0.8;
    largeSize = tileSize*1.3;
    currentSize = normalSize;
  }

  void display() {
    if (!isEmpty()) {
      fill(0);
      textSize(currentSize);
      textAlign(CENTER);
      text(letter, location.x, location.y + tileSize/5);
    }
  }

  void update() {
    if (isPulsing) {
      if (isRising) {
        currentSize = lerp(currentSize, largeSize, 0.2);
        if (currentSize > largeSize-2) {
          isRising = false;
        }
      } else {
        currentSize = lerp(currentSize, normalSize, 0.2);
        if (currentSize < normalSize+2) {
          isRising = true;
          isPulsing = false;
        }
      }
    }
  }

  void shine() {
    strokeWeight(3);
    stroke(#0582FC, 50);
    fill(#4CB7FC, 50);
    ellipse(location.x, location.y, tileSize, tileSize);
  }

  boolean isEmpty() {
    return letter == ' ';
  }

  boolean isUnderMouse() {
    return mouseX > location.x - tileSize/2 &&
      mouseX < location.x + tileSize/2 &&
      mouseY > location.y - tileSize/2 &&
      mouseY < location.y + tileSize/2;
  }
}
