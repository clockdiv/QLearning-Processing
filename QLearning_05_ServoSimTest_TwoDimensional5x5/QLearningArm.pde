
class QLearningArm {

  ArmSystem armsystem;

  int[] current_state;
  int[] previous_state;


  int[][] actions;
  float[][][] q_table;
  boolean first_run;
  float learning_rate;  
  float discount;
  float epsilon;        //the treshold deciding if a learned action from the q-table or a random action is used
  float old_score;
  int action_taken_index;
  boolean action_was_random;
  float maxValue = 0;


  QLearningArm() {
    actions = new int[][]{{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
    current_state = new int[2];
    previous_state = new int[2];

    first_run = true;
    learning_rate = 0.2;
    discount = 0.9;
    epsilon = 0.9;
  }



  void initialize_q_table() {
    // Initialize the table with random numbers
    q_table = new float[(int)sqrt(armsystem.states)][(int)sqrt(armsystem.states)][actions.length];

    for (int i = 0; i < q_table.length; i++) {
      for (int j = 0; j < q_table[0].length; j++) {
        for (int k = 0; k < q_table[0][0].length; k++) {
          q_table[i][j][k] = random(1.0);
        }
      }
    }
  }


  void draw_q_table() {
    textSize(16);
    fill(0);



    // Draw the table with all the numbers. 
    // The current state is highlighted by a grey box
    for (int i = 0; i < q_table.length; i++) {
      for (int j = 0; j < q_table[0].length; j++) {
        float x = (float(i) - float(q_table.length)/2.0) * 120.0;
        int y = j * 120;
        if (current_state[0] == i && current_state[1] == j) {
          fill(0, 11);
          rect(x-15, y-15, 90, 90);
        }

        // just find highest value for visualisation
        maxValue = 0;
        int maxValueIndex = 0;
        for (int k = 0; k < q_table[0][0].length; k++) {
          if ( q_table[i][j][k] > maxValue) {maxValue = q_table[i][j][k]; maxValueIndex = k;}
        }
        for (int k = 0; k < q_table[0][0].length; k++) {
          //          if ( q_table[i][j][k] > maxValue) maxValue = q_table[i][j][k];
          int c = int((q_table[i][j][k]) * 127.0/maxValue);
          fill(127 - c, c, 0);
          if(k == maxValueIndex) fill(0, 255, 0);
          pushMatrix();
          if (k < 4) {
            translate(k%3*30, k/3*30);
          } else {
            translate((k+1)%3*30, (k+1)/3*30);
          }
          text(nf(q_table[i][j][k], 1, 1), x, y);
          popMatrix();
        }
      }
    }

    // Draw a tiny box representing the last action taken at the previous state
    float x = (float(previous_state[0]) - float(q_table.length)/2.0) * 120.0;
    int y = previous_state[1] * 120;
    pushMatrix();
    if (action_taken_index < 4) {
      translate(action_taken_index%3*30, action_taken_index/3*30);
    } else {
      translate((action_taken_index+1)%3*30, (action_taken_index+1)/3*30);
    }
    if (action_was_random) fill(255, 0, 0, 66); 
    else fill(0, 22);
    rect(x-15, y-15, 30, 30);
    popMatrix();
  }


  int[] get_input() {
    if (first_run) {
      initialize_q_table(); 
      first_run = false;
    } else {
      int r = 0;
      if (old_score < armsystem.score)
        r = 1;      // new game score is heigher, reward is 1
      else if (old_score > armsystem.score)
        r = -1;     // new game score is lower, reward is -1

      //      if(r == 1 && epsilon < 1.0) {epsilon += 0.001; println("epsilon: " + epsilon);}
      int[] outcome_state = new int[current_state.length];
      arrayCopy(current_state, outcome_state);
      q_table[previous_state[0]][previous_state[1]][action_taken_index] += learning_rate * (r + discount * max(q_table[outcome_state[0]][outcome_state[1]]) - q_table[previous_state[0]][previous_state[1]][action_taken_index]);
    }

    old_score = armsystem.score;
    arrayCopy(current_state, previous_state);


    if (random(1.0) > epsilon) {       // select random action
      action_taken_index = int(random(actions.length));
      action_was_random = true;
    } else {                          // select action based on q table
      action_taken_index = getIndexOfLargest(q_table[current_state[0]][current_state[1]]);
      action_was_random = false;
    }
    return actions[action_taken_index];
  }



  public int getIndexOfLargest( float[] array )
  {
    if ( array == null || array.length == 0 ) return -1; // null or empty

    int largest = 0;
    for ( int i = 1; i < array.length; i++ )
    {
      if ( array[i] > array[largest] ) largest = i;
    }
    return largest; // position of the first largest found
  }
}
