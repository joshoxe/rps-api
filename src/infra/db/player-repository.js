const { Repository } = require('./repository');

module.exports = class PlayerRepository extends Repository {
  constructor() {
    super();
    this.table = 'players';
  }

  async add(player) {
    if (!player.connectionId) {
      throw 'Player must have a websocket connection ID';
    }

    const query = {
      text: 'INSERT INTO $1(connection_id, room_id) VALUES($2, $3);',
      values: [this.table, player.connectionId, player.roomId],
    };

    return this.dataContext.query(query);
  }

  async addRoomToPlayer(roomId, playerId) {
    const query = {
      text: 'UPDATE $1 SET room_id = $2 WHERE id = $3;',
      values: [this.table, roomId, playerId],
    };

    return this.dataContext.query(query);
  }
};
