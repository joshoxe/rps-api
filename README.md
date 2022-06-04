# Rock Paper Scissors (API)

This repository manages the backend of a Vue/NodeJS Rock Paper Scissors application. The application is a stateful 2-player game of rock paper scissors, where the current state of the game is stored in an SQL database.

## Architecture

The server-side code is wrriten as multiple AWS Lambdas, each handling a section of game logic. The state is stored in a PostgreSQL AWS RDS database. Both the Lambda and the RDS database are deployed inside of a Virtual Private Cloud with private-only routing (no access from the public internet). The Lambdas are invoked via a Websocket using API Gateway. A websocket allows two-way communication between the client and the server.

### Lambdas

#### onConnect

The first lambda handles incoming connections from the Websocket.

#### onDisconnect

The second lambda handles a client disconnecting from the Websocket.

#### play

The third lambda handles general game-related events, such as a player selecting a hand or pressing `ready`.
