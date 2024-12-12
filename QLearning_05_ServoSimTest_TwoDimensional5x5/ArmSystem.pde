class ArmSystem {
  int states; 
  int start_position;
  float score;
  int moves;
  QLearningArm qla;
  PVector tip;
  PVector tip_old;
  PVector lastServo;
  int yPos = 500;
  PVector root;

  float interpolation = 1.0;

  color scoreColor;

  ArmSystem (QLearningArm arm) {
    states = (int)sq(5);
    start_position = (int)random(states);
    this.qla = arm;
    qla.current_state[0] = 2;
    qla.current_state[1] = 2;
    score = 0;
    moves = 0;
    tip = new PVector();
    tip_old = new PVector();
    lastServo = new PVector();
    root = new PVector();
    scoreColor = color(127, 127, 127);
  }



  void run() {
    int[] move = qla.get_input();

    moves++;
    qla.current_state[0] += move[0];
    qla.current_state[1] += move[1];
    scoreColor = color(127, 127, 127);
    if (qla.current_state[0] < 0 || qla.current_state[0] > sqrt(states)-1 || qla.current_state[1] < 0 || qla.current_state[1] > sqrt(states)-1) {

      // impossible step

      arrayCopy(qla.previous_state, qla.current_state);
      score -= 10;
      scoreColor = color(0, 0, 255);  // scoreColor turns blue
    }
    /*else {
     
     // possible step, what follows is the scoring system
     
     if (tip.y - root.y > 0 && qla.previous_state[0] != 4) {
     fill(0, 255, 0);
     rect(0, 0, 200, 200);
     if ((tip.x - tip_old.x) < 0)
     {
     // that was bad, scoreColor turns red
     //score += (tip.x - tip_old.x) / 5;
     score--;
     scoreColor = color(255, 0, 0);
     } else if ((tip.x - tip_old.x) > 0)
     {
     // that was good, scoreColor turns green
     //score += (tip.x - tip_old.x) / 5;
     score++;
     scoreColor = color(0, 255, 0);
     } else {
     // that was nothing, scoreColor turns grey
     scoreColor = color(127, 127, 127);
     }
     //println(moves + ": dig it " + nf(tip.y - yPos, 3, 2) + " length: " + (int)((tip.x - tip_old.x)/10)+ " score: " + score + " pos old: " + tip_old + " pos: " + tip);
     }
     }
     tip_old.x = tip.x;
     tip_old.y = tip.y;
     */

    interpolation = 1.0;
  }


  void drawServos() {
    float angle = 180/(sqrt(states)-1);
    float servo1 = lerp(qla.current_state[0] * angle, qla.previous_state[0] * angle, interpolation);
    float servo2 = lerp(qla.current_state[1] * angle, qla.previous_state[1] * angle, interpolation);

    interpolation -= 0.125;
    if (interpolation <= 0)
      interpolation = 0;

    root.x = screenX(0, 0);
    root.y = screenY(0, 0);

    rotate(radians(180 + servo1));
    fill(0, 255, 0);

    ellipse(0, 0, 10, 10);
    rect(0, -4, 100, 4);

    translate(100, 0);

    rotate(radians(180 + servo2));
    fill(255, 0, 0);
    ellipse(0, 0, 10, 10);
    rect(0, -4, 100, 4);



    // Calculate the score during movement
    if (tip.y - root.y > -10 && tip.x - root.x < 0 ) {
      if ((tip.x - tip_old.x) < 0)
      {
        // that was bad, scoreColor turns red
        //score += (tip.x - tip_old.x) / 5;
        score--;
        scoreColor = color(255, 0, 0);
      } else if ((tip.x - tip_old.x) > 0)
      {
        // that was good, scoreColor turns green
        //score += (tip.x - tip_old.x) / 5;
        score++;
        scoreColor = color(0, 255, 0);
      } else {
        // that was nothing, scoreColor turns grey
        //scoreColor = color(127, 127, 127);
      }
      fill(scoreColor);
      rect(100, 0, 20, 20);
      //println(moves + ": dig it " + nf(tip.y - yPos, 3, 2) + " length: " + (int)((tip.x - tip_old.x)/10)+ " score: " + score + " pos old: " + tip_old + " pos: " + tip);
    }
  
  tip_old.x = tip.x;
  tip_old.y = tip.y;



  tip.x = screenX(100, 0);
  tip.y = screenY(100, 0);
}
}
