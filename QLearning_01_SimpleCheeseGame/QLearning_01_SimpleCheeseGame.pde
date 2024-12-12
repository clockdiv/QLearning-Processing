// https://www.practicalai.io/teaching-ai-play-simple-game-using-q-learning/

Player p;
Game g;

void setup() {
  size(650, 600);

  p = new Player();
  g = new Game(p);

}


void draw() {
  g.run();

  pushMatrix();
  translate(100, 100);
  background(255);
  g.drawgame();
  popMatrix();
  
  
  textSize(18);
  textAlign(CENTER);
  fill(0);
  text("moves: " + g.moves + " score: " + g.score, width/2, 30);
  text("move with 'a' to left and 'd' to the right", width/2, 200);

  
  pushMatrix();
  translate(width/2 - 30, 190);
  popMatrix();
  
}


void keyPressed() {
  switch(key) {
  case 'a':
    p.input = -1;
    break;
  case 'd':
    p.input = 1;
    break;
  default:
    break;
  }
}
