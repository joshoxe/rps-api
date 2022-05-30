class GameEvent {
  constructor(type, value, player) {
    this.type = type;
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
