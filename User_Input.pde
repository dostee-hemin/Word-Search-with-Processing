void keyPressed() {
  if (key == 'r') {
    // Reset
    LoadWords();
    
    // Generate a new board
    board = new Board(boardSize, boardSize);
    board.generateNewBoard();

    // Reset all variables
    wordsFound.clear();
    currentColor = 0;
    showEndText = false;
    endTextAlpha = 0;
  }
}

void mousePressed() {
  // Start drawing the word line
  board.startWordLine();
}
void mouseDragged() {
  // Start generating the word line if the mouse is in the board
  isDragging = board.mouseIsInBoard();
}

void mouseReleased() {
  // If the word selected is a correct word and hasn't already been found...
  if (chosenWords.contains(selectedWord) && !wordsFound.contains(selectedWord)) {
    // Add it to the wordsFound list
    wordsFound.add(selectedWord);

    // Change the current color of highlight
    if (currentColor < wordColors.length-1) {
      currentColor++;
    }
    
    // Pulse the letters that have just been found and play the sound effect
    board.showFound();
    foundSound.play();
  } 
  
  // If the selected word is wrong
  else {
    if (!board.wordLines.isEmpty()) {
      // Remove the highlight and play the deselect sound effect
      board.wordLines.remove(board.wordLines.size()-1);
      deselectSound.play();
    }
  }
  
  isDragging = false;
  board.deselectAllTiles();
}
