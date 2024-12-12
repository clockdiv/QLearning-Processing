class Player {
  int x;
  int input;

  Player() {
    x = 0;
  }

  int get_input() {
    int _input = input;
    input = 0;
    return _input;
  }
}
