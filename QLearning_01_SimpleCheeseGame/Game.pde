class Game {

  int run;
  int map_size; 
  int start_position;
  int cheese_x;
  int pit_x;
  int score;
  int moves;
  Player player;



  Game (Player _player) {

    run = 0;
    map_size = 12;
    start_position = 3;
    player = _player;
    reset();
  }



  void reset() {

    player.x = start_position;
    cheese_x = 10;
    pit_x = 0;
    score = 0;
    run += 1;
    moves = 0;
  }



  void run() {

    if (score < 5 && score > -5) {
      int move = player.get_input();  // get_input returns one of both actions, -1 or +1
      if (move == 0) return;        //nothing happend, return

      moves++;
      player.x += move;        // either -1 or +1

      if (player.x < 0) {
        player.x = map_size - 1;
      } else if (player.x > map_size - 1) {
        player.x = 0;
      } else if (player.x == cheese_x) {
        score++;
        player.x = start_position;
      } else if (player.x == pit_x) {
        score--;
        player.x = start_position;
      }
      return;
    }

    println("run: " + run);
    if (score >= 5) {
      println("You win in " + moves + " moves!");
      g.reset();
    } else {
      println("Game over");
      g.reset();
    }
  }




  void drawgame() {
    stroke(0);
    for (int i = 0; i < map_size; i++) {
      fill(0);
      textAlign(CENTER);
      text(i, i*40, 40);
      if (player.x == i) {
        fill(127);
      } else if (cheese_x == i) {
        fill(0, 255, 0);
      } else if (pit_x == i) {
        fill(255, 0, 0);
      } else {
        noFill();
      }
      ellipse(i * 40, 0, 30, 30);
    }
  }
}
