class QLearningArm {

  ArmSystem armsystem;

  int current_state;
  int previous_state;

  int[] actions;
  float[][] q_table;
  boolean first_run;
  float learning_rate;  
  float discount;
  float epsilon;        //the treshold deciding if a learned action from the q-table or a random action is used
  int old_score;
  int action_taken_index;
float maxValue = 0;


  QLearningArm() {
    current_state = 0;// = new int[]{ 0, 0};
    actions = new int[]{-6, -5, -4, -1, 1, 4, 5, 6};
    first_run = true;
    learning_rate = 0.2;
    discount = 0.9;
    epsilon = 0.9;
  }



  void initialize_q_table() {
    // Initialize the table with random numbers
    q_table = new float[armsystem.states][actions.length];
    for (int i = 0; i < armsystem.states; i++) {
      for (int j = 0; j < actions.length; j++) {
        q_table[i][j] = random(1.0);
      }
    }
  }


  void draw_q_table() {
    textSize(14);
    fill(0);
    for (int j = 0; j < q_table[0].length; j++) text(actions[j], j * 60, -30);
    for (int i = 0; i < q_table.length; i++) {
      fill(0);
      text(i + ": ", -40, i* 30);
      if(i == current_state){
        noFill();
        stroke(0);
        ellipse(-40, i * 30, 30, 30);  
      }
      for (int j = 0; j < q_table[0].length; j++) {
        if( q_table[i][j] > maxValue) maxValue = q_table[i][j];
        int c = int((q_table[i][j]) * 255.0/maxValue);
        fill(255 - c, c, 0);
        text(nf(q_table[i][j], 1, 2), j*60, i*30);
      }
    }
  }


  int get_input() {
    //delay(200);
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

      int outcome_state = current_state;
      q_table[previous_state][action_taken_index] += learning_rate * (r + discount * max(q_table[outcome_state]) - q_table[previous_state][action_taken_index]);
    }

    old_score = armsystem.score;
    previous_state = current_state;


    if (random(1.0) > epsilon) {       // select random action
      action_taken_index = int(random(actions.length));
    } else {                          // select action based on q table
      action_taken_index = getIndexOfLargest(q_table[current_state]);
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
