void LoadWords() {
  // Clear out everything to start fresh
  chosenWords.clear();
  catagory = "";
  
  // Load the text file into an array (each element is a catagory)
  String[] txt = loadStrings("Dictionary.txt");
  
  // Pick a random catagory and get the line of that catagory
  int catagoryIndex = floor(random(txt.length));
  String chosenLine = txt[catagoryIndex];
  
  // Read the first word up unitl the '-' (this is the catagory name)
  int currentI = 0;
  while (chosenLine.charAt(currentI) != '-') {
    catagory += chosenLine.charAt(currentI);
    currentI++;
  }
  
  // Store all possible words in this catagory into an array
  String[] allWords = chosenLine.substring(currentI+1, chosenLine.length()).split(" ");
  
  // While I haven't gotten all the words I need...
  while (chosenWords.size() != 12) {
    // Pick a random word (make it upper case)
    int index = floor(random(allWords.length));
    String currentWord = allWords[index].toUpperCase();
    
    // If the word is not too long and is not already chosen, add it to the list
    if (!chosenWords.contains(currentWord) && currentWord.length() <= boardSize) {
      chosenWords.add(currentWord);
    }
  }
  
  // Sort all the chosen words in order of decreasing size
  // (this improves the generation by placing the biggest words first)
  quickSort(0, chosenWords.size()-1);
}


/*    Simple Quick Sort Algorithm    */
void quickSort(int start, int end) {
  if(start >= end) {
    return;
  }
  
  int partitionIndex = partition(start, end);
  
  quickSort(start, partitionIndex-1);
  quickSort(partitionIndex+1, end);
}

int partition(int start, int end) {
  int partitionIndex = start;
  int partitionValue = chosenWords.get(end).length();
  for(int i=start; i<end; i++) {
    if(chosenWords.get(i).length() > partitionValue) {
      swap(partitionIndex, i);
      partitionIndex++;
    }
  }
  swap(partitionIndex, end);
  return partitionIndex;
}

void swap(int a, int b) {
  String temp = chosenWords.get(a);
  chosenWords.set(a,chosenWords.get(b));
  chosenWords.set(b,temp);
}
