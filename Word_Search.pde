import processing.sound.*;

int boardSize = 12;
float tileSize;

int endTextAlpha = 0;
boolean showEndText;
PImage endText;

Board board;

boolean isDragging;
PVector startTile;

color[] wordColors = {color(255, 247, 0), // Yellow
  color(73, 107, 240), // Dark Blue
  color(0, 219, 49), // Green
  color(252, 87, 46), // Red
  color(204, 46, 252), // Purple
  color(2, 213, 234), // Light Blue
  color(250, 121, 237), // Pink
  color(252, 140, 3), // Orange
  color(255, 77, 181), // Magenta
  color(176, 255, 93), // Lime
  color(118, 176, 255), // Ocean Blue
  color(255, 233, 118) // Light Orange
};
int currentColor = 0;
ArrayList<String> chosenWords = new ArrayList<String>();
ArrayList<String> wordsFound = new ArrayList<String>();
String catagory = "";
String selectedWord;

void setup() {
  size(800, 800);
  
  LoadWords();
  LoadSounds();

  tileSize = (width-300)/boardSize;
  board = new Board(boardSize, boardSize);
  endText = loadImage("Level Complete.png");
  endText.resize(500, 200);

  board.generateNewBoard();

  textFont(createFont("BalooChettan2-Bold.ttf", 100));
}

void draw() {
  background(20, 40, 57);

  board.display();
  
  fill(255);
  textSize(30);
  textAlign(CORNER);
  text("Catagory: " + catagory, 15, 40);
  textAlign(CENTER);
  text("Press 'r'", 70, 300);
  text("to Reset", 70, 330);

  if (isDragging) {
    board.generateLine();

    if (!selectedWord.equals("")) {
      // Band surrounding text
      strokeWeight(36);
      stroke(wordColors[currentColor]);
      line(width/2 - selectedWord.length()*9, 40, width/2 + selectedWord.length()*9, 40);

      // Highlighted text
      fill(0);
      textSize(30);
      textAlign(CENTER);
      text(selectedWord, width/2, 50);
    }
  }


  // Display all the words in this round

  // The box containing the words
  fill(#034D89, 100);
  stroke(#196DAF);
  strokeWeight(10);
  rect(width/2, height-120, width-180, 170, 7);

  // The words
  for (float i=0; i<chosenWords.size(); i++) {
    String s = chosenWords.get(int(i));
    float x = 200 + floor(i/4) * 200;
    float y = height-170 + i%4 * 40;
    fill(255);
    if (wordsFound.contains(s)) {
      fill(wordColors[wordsFound.indexOf(s)], 125);
    }
    textSize(25);
    textAlign(CENTER);
    text(s, x, y);
  }

  board.update();

  if (wordsFound.size() == 12) {
    if (frameCount % 50 == 0) {
      showEndText = true;
    }

    if (showEndText) {
      imageMode(CENTER);
      tint(0, endTextAlpha/2);
      image(endText, width/2, height/2 - (endTextAlpha/2) + 10);
      tint(255, endTextAlpha);
      image(endText, width/2, height/2 - (endTextAlpha/2));

      if (endTextAlpha < 255) {
        endTextAlpha += 7;
      }
    }
  }
}
