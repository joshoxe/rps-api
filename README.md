# Rock Paper Scissors (API)

This repository manages the backend of a Vue/NodeJS Rock Paper Scissors application. The application is a stateful 2-player game of rock paper scissors, where the current state of the game is stored in an SQL database.

## Architecture

The server-side code is wrriten as an AWS Lambda, and the state is stored in a PostgreSQL AWS RDS database. Both the Lambda and the RDS database are deployed inside of a Virtual Private Cloud with private-only routing (no access from the public internet). The Lambda is invoked using a public-facing API Gateway.
