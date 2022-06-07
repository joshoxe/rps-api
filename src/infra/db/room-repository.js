const { Repository } = require('./repository');

export class RoomRepository extends Repository {
  constructor() {
    super();
    this.table = 'rooms';
  }

  async add(room) {
    if (!room.roomId) {
      throw 'Room must have a unique ID';
    }

    const query = {
      text: 'INSERT INTO $1(room_id) VALUES($2);',
      values: [this.table, room.roomId],
    };

    return this.dataContext.query(query);
  }

  async getRoomPlayerCount(roomId) {
    const query = {
      text: 'SELECT COUNT(players.id) FROM players WHERE room_id = $1',
      values: [roomId],
    };

    return this.dataContext.query(query);
  }
}
