const PlayerRepository = require('../infra/db/player-repository');

module.exports.connect = async (event, context, callback) => {
  const playerRepository = new PlayerRepository();
  console.log(JSON.stringify(event));
  newPlayer = {
    connectionId: event.requestContext.connectionId,
    roomId: null,
  };

  console.log(`successfully created player: ${JSON.stringify(newPlayer)}`);

  this.headers = {
    'Access-Control-Allow-Origin': '*', // Required for CORS support to work
  };

  playerRepository
    .add(newPlayer)
    .then(() => {
      console.log(`successfully added player to db`);
      callback(null, {
        statusCode: 200,
        headers: this.headers,
        body: JSON.stringify({
          message: 'Connected',
        }),
      });
    })
    .catch(error => {
      console.error(JSON.stringify(error));
      callback(
        {
          statusCode: 500,
          headers: this.headers,
          body: JSON.stringify({
            message: error,
          }),
        },
        null
      );
    });
};
