class WordLine {
  PVector startPoint;
  PVector endPoint;
  
  color c;
  
  WordLine(PVector startPoint, color c) {
    this.startPoint = startPoint;
    endPoint = startPoint;
    
    this.c = c;
  }
  
  void setEndPoint(PVector endPoint) {
    this.endPoint = endPoint;
  }
  
  void display() {
    stroke(c, 175);
    strokeWeight(tileSize*0.9);
    line(startPoint.x,startPoint.y,endPoint.x,endPoint.y);
  }
}
