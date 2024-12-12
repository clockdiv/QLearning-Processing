// https://www.practicalai.io/teaching-ai-play-simple-game-using-q-learning/

import java.util.Arrays;

QLearningArm q;
ArmSystem a;

boolean pause;
boolean slowmotion;

long t;
int interval;
int slow = 1000;

void setup() {
  size(1920, 1200);

  frameRate(240);
  interval = slow;
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
  if (millis() - t > interval && !pause) {
    a.run();
    t = millis();
  }
  

  // Draw the QTable
  pushMatrix();
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
  text(/*"x: " + nf(a.tip.x - a.root.x, 0, -1) + " y: " + nf(a.tip.y - a.root.y, 0, -1) + " | " + */(a.tip.x - a.tip_old.x), a.tip.x+20, a.tip.y-20);

//  fill(a.scoreColor);
//  ellipse(300, 500, 30, 30);


  // Draw text
  textSize(18);
  fill(0);
  text("moves: " + a.moves + " score: " + a.score, width/2, 30);
  text("slowmotion (key 's') is " + (slowmotion ? "on" : "off"), width/2, 60);
  text("pause (key 'p') is " + (pause ? "on, hit 'n' for next step" : "off"), width/2, 90);
  text("epsilon is " + nf(a.qla.epsilon,0,1), width/2, 120);


}



void keyPressed() {
  if (key == 'p') {
    pause = !pause;
  } else if (key == 's') {
    slowmotion = !slowmotion;
    if (slowmotion) {
      interval = slow;
    } else {
      interval = 2;
    }
  } else if (key == 'n') {
       a.run();
  } else if (key == '+') {
    a.qla.epsilon += 0.1;
    if(a.qla.epsilon > 1.0) a.qla.epsilon = 1.0;
  } else if (key == '-') {
    a.qla.epsilon -= 0.1;
    if(a.qla.epsilon < 0.0) a.qla.epsilon = 0.0;
  }
}
