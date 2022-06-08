const PlayerRepository = require('../infra/db/player-repository');

module.exports.connect = async (event, context, callback) => {
  const playerRepository = new PlayerRepository();
  const newPlayer = {};
  try {
    newPlayer = {
      connectionId: event.requestContext.connectionId,
      roomId: null,
    };
  } catch (err) {
    callback(null, {
      statusCode: 200,
      headers: { 'Access-Control-Allow-Origin': '*' }, // Required for CORS support to work
      body: JSON.stringify(event),
    });
  }

  this.headers = {
    'Access-Control-Allow-Origin': '*', // Required for CORS support to work
  };

  playerRepository
    .add(newPlayer)
    .then(() => {
      callback(null, {
        statusCode: 200,
        headers: this.headers,
        body: JSON.stringify({
          message: 'Connected',
        }),
      });
    })
    .catch(error => {
      callback(null, {
        statusCode: 500,
        headers: this.headers,
        body: JSON.stringify({
          message: error,
        }),
      });
    });
};
