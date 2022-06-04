class GameEvent {
  constructor(action, value, player) {
    this.action = action;
    this.value = value;
    this.player = player;
  }

  set player(value) {
    if (value < 0 || value > 1) {
      throw "Argument out of range. Must be 0 or 1.";
    }

    this.value = value;
  }
}
