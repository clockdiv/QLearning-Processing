class ArmSystem {
  int states; 
  int start_position;
  int score;
  int moves;
  QLearningArm qla;


  ArmSystem (QLearningArm arm) {
    states = 25;
    start_position = 12;
    this.qla = arm;
    qla.current_state = start_position;
    score = 0;
    moves = 0;
  }



  void run() {
    int move = qla.get_input();

    int prev_armpos = qla.current_state;
    moves++;
    qla.current_state += move;

    if (qla.current_state < 0 || qla.current_state > states-1) {
      qla.current_state = qla.previous_state; 
      score--;
    } else if (prev_armpos == 2 && qla.current_state == 1) {
      score++;
    } else if (prev_armpos == 3 && qla.current_state == 2) {
      score++;
    } else if (prev_armpos == 1 && qla.current_state == 2) {
      score--;
    } else if (prev_armpos == 2 && qla.current_state == 3) {
      score--;
    }
  }


  void drawServos() {
    int servo1 = qla.current_state / 5 * 45;
    int servo2 = qla.current_state % 5 * 45;

    rotate(radians(180 + servo1));
    fill(0, 255, 0);
    ellipse(0, 0, 10, 10);
    rect(0, -4, 100, 4);

    translate(100, 0);

    rotate(radians(180 + servo2));
    fill(255, 0, 0);
    ellipse(0, 0, 10, 10);
    rect(0, -4, 100, 4);
  }
}
