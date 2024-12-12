// https://www.practicalai.io/teaching-ai-play-simple-game-using-q-learning/

QLearningPlayer p;
Game g;

boolean nextStep = true;

void setup() {

  size(650, 600);

  p = new QLearningPlayer();
  g = new Game(p);
  p.game = g;
}

void draw() {
  if (nextStep) {
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


    pushMatrix();
    translate(width/2 - 30, 190);
    p.draw_q_table();
    popMatrix();

    nextStep = true;
  }
}

void mousePressed() {
  nextStep = true;
}
