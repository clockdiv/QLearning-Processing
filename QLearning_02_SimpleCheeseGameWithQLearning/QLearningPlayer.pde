class QLearningPlayer {
  Game game;
  int x;
  int[] actions;
  float[][] q_table;
  boolean first_run;
  float learning_rate;  
  float discount;
  float epsilon;        //the treshold deciding if a learned action from the q-table or a random action is used
  int old_score;
  int old_x;
  int action_taken_index;



  QLearningPlayer() {
    x = 0;
    actions = new int[]{-1, 1};
    first_run = true;
    learning_rate = 0.2;
    discount = 0.9;
    epsilon = 0.9;
  }



  void initialize_q_table() {
    // Initialize the table with random numbers
    q_table = new float[game.map_size][actions.length];
    for (int i = 0; i < game.map_size; i++) {
      for (int j = 0; j < actions.length; j++) {
        q_table[i][j] = random(1.0);
      }
    }
  }


  void draw_q_table() {
    textSize(14);
    stroke(0);
    for (int i = 0; i < q_table.length; i++) {
      fill(0);
      text(i + ": ", -40, i* 30);
      for (int j = 0; j < q_table[0].length; j++) {
        int c = int((q_table[i][j]) * 255.0);
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
      return 0;
    } else {
      int r = 0;
      if (old_score < game.score)
        r = 1;      // new game score is heigher, reward is 1
      else if (old_score > game.score)
        r = -1;     // new game score is lower, reward is -1

//      if(r == 1 && epsilon < 1.0) {epsilon += 0.001; println("epsilon: " + epsilon);}
      
      int outcome_state = x;
      q_table[old_x][action_taken_index] += learning_rate * (r + discount * max(q_table[outcome_state]) - q_table[old_x][action_taken_index]);
    }

    old_score = game.score;
    old_x = x;


    if (random(1.0) > epsilon) {       // select random action
      action_taken_index = int(random(actions.length));
    } else {                          // select action based on q table
      if (q_table[x][0] > q_table[x][1]) 
        action_taken_index = 0;
      else 
      action_taken_index = 1;
    }
    return actions[action_taken_index];
  }
}
