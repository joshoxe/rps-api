const { Client } = require('pg');

module.exports = class DataContext {
  /**
   * Create a new DataContext, using environment variables to connect to a PostgreSQL database.
   */
  constructor() {
    this.client = new Client();
  }

  async query(query) {
    console.log('connecting to database..');
    await this.client.connect();
    console.log('connected');

    console.log('querying database..');
    const result = await this.client.query(query);

    console.log('query complete');
    console.log(JSON.stringify(result));
    return result;

    // this.client
    //   .query(query)
    //   .then(async result => {
    //     await this.client.end();
    //     return result.rows[0];
    //   })
    //   .catch(async error => {
    //     await this.client.end();
    //     throw error.stack;
    //   });
  }
};
