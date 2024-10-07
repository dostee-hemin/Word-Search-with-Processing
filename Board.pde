class Board {
  int columns;
  int rows;

  int pulseI;

  Tile[][] tiles;
  ArrayList<WordLine> wordLines = new ArrayList<WordLine>();
  PVector previousMouseTile;

  Board(int columns, int rows) {
    this.columns = columns;
    this.rows = rows;

    tiles = new Tile[columns][rows];
    for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {
        float x = 150 + tileSize/2 + i*tileSize;
        float y = 75 + tileSize/2 + j*tileSize;
        tiles[i][j] = new Tile(x, y);
      }
    }

    previousMouseTile = new PVector(-1, -1);
  }

  void generateNewBoard() {
    for (String s : chosenWords) {
      addWord(s);
    }
    fillUp();
  }

  void update() {
    for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {          
        tiles[i][j].update();
      }
    }

    if (pulseI < columns+rows) {
      if (pulseI == 0) {
        swooshSound.play();
      }
      int j=0;
      for (int i=pulseI; i>=0; i--) {
        if (i < columns && j < rows) {
          tiles[i][j].isPulsing = true;
        }
        j++;
      }
      pulseI++;
    }
  }

  void showFound() {
    for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {
        if (tiles[i][j].isSelected) {
          tiles[i][j].isPulsing = true;
        }
      }
    }
  }

  void display() {
    noStroke();
    fill(255);
    rectMode(CENTER);
    rect(width/2, 75 +(boardSize/2)*tileSize, width-300, width-300, 7);

    // Display all the lines drawn
    for (WordLine w : wordLines) {
      w.display();
    }
    // Display all the tiles
    for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {
        tiles[i][j].display();
      }
    }    
    // Shine the tile the mouse is currently on
    if (mouseIsInBoard()) {
      int i = round((mouseX-(150 + tileSize/2))/tileSize);
      int j = round((mouseY-(75 + tileSize/2))/tileSize);
      tiles[i][j].shine();
    }
  }

  void addWord(String newWord) {
    // Pick a direction that the word will be written in
    PVector direction = new PVector(round(random(-1.5, 1.5)), round(random(-1.5, 1.5)));
    if (direction.mag() == 0) {
      direction.x = 1;
    }

    // The current tile that the printer is on
    // (currently hasn't found a starting position)
    PVector currentTile = new PVector(-1, -1);

    // While the new word can not be placed on the board
    int counter = 0;
    boolean canBePlaced = false;
    while (!canBePlaced) {
      // Pick a new starting location
      currentTile = pickStart(direction, newWord.length());

      // Move in that direction checking letter by letter
      // if it can be placed on the board
      for (int currentChar=0; currentChar<newWord.length(); currentChar++) {
        PVector index = PVector.add(currentTile, PVector.mult(direction, currentChar));
        Tile t = tiles[int(index.x)][int(index.y)];
        if (!t.isEmpty() && t.letter != newWord.charAt(currentChar)) {
          canBePlaced = false;
          break;
        }
        canBePlaced = true;
      }


      // Increase the counter after every try.
      // If there is a stack overflow,
      // pick a new direction and try again
      counter++;
      if (counter > 500) {
        counter = 0;

        direction = new PVector(round(random(-1.5, 1.5)), round(random(-1.5, 1.5)));
        if (direction.mag() == 0) {
          direction.x = 1;
        }
      }
    }

    // By this point, we know that the word can be placed in a specific way,
    // so now we place the tile
    for (int currentChar=0; currentChar<newWord.length(); currentChar++) {
      Tile t = tiles[int(currentTile.x)][int(currentTile.y)];
      t.letter = newWord.charAt(currentChar);
      currentTile.add(direction);
    }
  }

  PVector pickStart(PVector direction, int wordLength) {
    int startI = -1;
    int startJ = -1;

    switch(floor(direction.x)) {
    case -1:
      startI = floor(random(wordLength-1, columns));
      break;
    case 0:
      startI = floor(random(columns));
      break;
    case 1:
      startI = floor(random(columns-wordLength));
      break;
    }

    switch(floor(direction.y)) {
    case -1:
      startJ = floor(random(wordLength-1, rows));
      break;
    case 0:
      startJ = floor(random(rows));
      break;
    case 1:
      startJ = floor(random(rows-wordLength));
      break;
    }

    return new PVector(startI, startJ);
  }

  void fillUp() {
    char[] letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {
        if (tiles[i][j].letter == ' ') {
          tiles[i][j].letter = letters[floor(random(letters.length))];
        }
      }
    }
  }

  void startWordLine() {
    if (board.mouseIsInBoard()) {
      selectSound.play();
      int i = round((mouseX-(150 + tileSize/2))/tileSize);
      int j = round((mouseY-(75 + tileSize/2))/tileSize);
      startTile = new PVector(i, j);
      wordLines.add(new WordLine(tiles[i][j].location.copy(), wordColors[currentColor]));
    }
  }

  boolean mouseIsInBoard() {
    return mouseX > 150 && mouseX < 150 + tileSize*boardSize && 
      mouseY > 75 && mouseY < 75 + tileSize*boardSize;
  }

  void generateLine() {
    int i = round((mouseX-(150 + tileSize/2))/tileSize);
    int j = round((mouseY-(75 + tileSize/2))/tileSize);
    PVector mouseTile = new PVector(i, j);

    // Check to see if the mouse didn't start from outside the board and move in
    if (wordLines.isEmpty()) {
      selectedWord = "";
      return;
    }

    // If the player hasn't moved the mouse, 
    // there is no need to calculate a new line so leave the function
    if (previousMouseTile.x == mouseTile.x && previousMouseTile.y == mouseTile.y) {
      return;
    }
    moveSound.play();

    selectedWord = "";
    deselectAllTiles();

    PVector startToMouse = PVector.sub(mouseTile, startTile).normalize();
    PVector direction = startToMouse.copy();
    direction.x = round(direction.x);
    direction.y = round(direction.y);

    PVector current = startTile.copy();
    if (startToMouse.heading() % HALF_PI == 0) {
      while (!(current.x == mouseTile.x && current.y == mouseTile.y)) {
        tiles[int(current.x)][int(current.y)].isSelected = true;
        selectedWord += tiles[int(current.x)][int(current.y)].letter;
        current.add(direction);
      }
    } else {
      while (current.x != mouseTile.x && current.y != mouseTile.y) {
        tiles[int(current.x)][int(current.y)].isSelected = true;
        selectedWord += tiles[int(current.x)][int(current.y)].letter;
        current.add(direction);
      }
    }
    tiles[int(current.x)][int(current.y)].isSelected = true;
    selectedWord += tiles[int(current.x)][int(current.y)].letter;

    WordLine currentLine = wordLines.get(wordLines.size()-1);
    currentLine.setEndPoint(current.mult(tileSize).add(150 + tileSize/2, 75 + tileSize/2));

    previousMouseTile = mouseTile;
  }

  void deselectAllTiles() {
    for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {
        tiles[i][j].isSelected = false;
      }
    }
  }
}
