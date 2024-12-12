// https://www.practicalai.io/teaching-ai-play-simple-game-using-q-learning/

import java.util.Arrays;

QLearningArm q;
ArmSystem a;

boolean pause;
boolean slowmotion;

long t;
int interval;

void setup() {
  size(1920, 1200);

  frameRate(60);
  interval = 500;
  q = new QLearningArm();
  a = new ArmSystem(q);
  q.armsystem = a;
  pause = false;
  slowmotion = true;
  t = millis();
  a.run();

  textAlign(CENTER);
}



void draw() {
  background(255);

  // run the algorithm every interval
  if (millis() - t > interval) {
    a.run();
    t = millis();
  }
  

  // Draw the QTable
  pushMatrix();
  fill(a.scoreColor);
  ellipse(300, 500, 30, 30);
  translate(width/2, 160);
  q.draw_q_table();
  popMatrix();


  // Draw the servos
  pushMatrix();
  translate(300, 500);
  a.drawServos();
  popMatrix();
  stroke(0, 20);
  line(0, a.tip.y, width, a.tip.y);
  line(a.tip.x, 0, a.tip.x, height);
  fill(0);
  text("x: " + nf(a.tip.x, 0, -1) + " y: " + nf(a.tip.y, 0, -1), a.tip.x+20, a.tip.y-20);

  
  // Draw text
  textSize(18);
  fill(0);
  text("moves: " + a.moves + " score: " + a.score, width/2, 30);
  text("slowmotion (key 's') is " + (slowmotion ? "on" : "off"), width/2, 60);
  text("pause (key 'p') is " + (pause ? "on" : "off"), width/2, 90);


}



void keyPressed() {
  if (key == 'p') {
    pause = !pause;
    if (pause) {
      draw();
      noLoop();
    } else {
      loop();
    }
  } else if (key == 's') {
    slowmotion = !slowmotion;
    if (slowmotion) {
      interval = 500;
    } else {
      interval = 15;
    }
  }
}
