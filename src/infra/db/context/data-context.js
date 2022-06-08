const Client = require('pg');

module.exports = class DataContext {
  /**
   * Create a new DataContext, using environment variables to connect to a PostgreSQL database.
   */
  constructor() {
    this.client = new Client();
  }

  async query(query) {
    await this.client.connect();
    this.client
      .query(query)
      .then(async result => {
        await this.client.end();
        return result.rows[0];
      })
      .catch(async error => {
        await this.client.end();
        throw error.stack;
      });
  }
};
