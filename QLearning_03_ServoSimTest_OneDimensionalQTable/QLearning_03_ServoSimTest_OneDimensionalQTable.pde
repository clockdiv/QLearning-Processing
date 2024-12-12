// https://www.practicalai.io/teaching-ai-play-simple-game-using-q-learning/

import java.util.Arrays;

QLearningArm q;
ArmSystem a;

boolean pause;
boolean slowmotion;

void setup() {
  size(1280, 1280);
  frameRate(5);
  q = new QLearningArm();
  a = new ArmSystem(q);
  q.armsystem = a;
  pause = false;
  slowmotion = true;
}



void draw() {
  background(255);

  a.run();

  pushMatrix();
  translate(300, 500);
  a.drawServos();
  popMatrix();


  textSize(18);
  textAlign(CENTER);
  fill(0);
  text("moves: " + a.moves + " score: " + a.score, width/2, 30); 

  text("slowmotion (key 's') is " + (slowmotion ? "on" : "off"), width/2, 60);
  text("pause (key 'p') is " + (pause ? "on" : "off"), width/2, 90);

  pushMatrix();
  translate(width/2 - 30, 190);
  q.draw_q_table();
  popMatrix();
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
      frameRate(5);
    } else {
      frameRate(240);
    }
  }
}
