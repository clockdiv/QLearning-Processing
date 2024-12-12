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

  float interpolation = 1.0;

  color scoreColor;

  ArmSystem (QLearningArm arm) {
    states = (int)sq(8);
    start_position = (int)random(states);
    this.qla = arm;
    qla.current_state[0] = 2;
    qla.current_state[1] = 2;
    score = 0;
    moves = 0;
    tip = new PVector();
    tip_old = new PVector();
    lastServo = new PVector();
    scoreColor = color(127, 127, 127);
  }



  void run() {
    int[] move = qla.get_input();

    moves++;
    qla.current_state[0] += move[0];
    qla.current_state[1] += move[1];
    scoreColor = color(127, 127, 127);
    if (qla.current_state[0] < 0 || qla.current_state[0] > sqrt(states)-1 || qla.current_state[1] < 0 || qla.current_state[1] > sqrt(states)-1) {
      arrayCopy(qla.previous_state, qla.current_state);
      score -= 10;
      scoreColor = color(0, 0, 255);  // wanted to do an impossible step -> scoreColor turns blue
    }

    tip_old.x = tip.x;
    tip_old.y = tip.y;

    interpolation = 1.0;
  }


  void drawServos() {
    float angle = 180/(sqrt(states)-1);
    float servo1 = lerp(qla.current_state[0] * angle, qla.previous_state[0] * angle, interpolation);
    float servo2 = lerp(qla.current_state[1] * angle, qla.previous_state[1] * angle, interpolation);

    interpolation -= 0.25;
    if (interpolation <= 0)
      interpolation = 0;

    rotate(radians(180 + servo1));
    fill(0, 255, 0);

    ellipse(0, 0, 10, 10);
    rect(0, -4, 100, 4);

    translate(100, 0);

    rotate(radians(180 + servo2));
    fill(255, 0, 0);
    ellipse(0, 0, 10, 10);
    rect(0, -4, 100, 4);
    //    fill(0, 0, 255);
    //    ellipse(100, 0, 10, 10);

    tip.x = screenX(100, 0);
    tip.y = screenY(100, 0);


    // here is the hard-coded scoring system. this would be exchanged with a sensor later.
    if (tip.y - yPos > 0.1) {
      if ((tip.x - tip_old.x) < 0)
      {
        // that was bad, scoreColor turns red
        score += (tip.x - tip_old.x) / 5;
        scoreColor = color(255, 0, 0);
      } else if ((tip.x - tip_old.x) > 0)
      {
        // that was good, scoreColor turns green
        score += (tip.x - tip_old.x) / 5;
        scoreColor = color(0, 255, 0);
      } else {
        // that was nothing, scoreColor turns grey
        scoreColor = color(127, 127, 127);
      }
      //println(moves + ": dig it " + nf(tip.y - yPos, 3, 2) + " length: " + (int)((tip.x - tip_old.x)/10)+ " score: " + score + " pos old: " + tip_old + " pos: " + tip);
    }

    tip_old.x = tip.x;
    tip_old.y = tip.y;
  }
}
