import { Client } from "pg";

export class DataContext {
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
      .then(result => {
          await this.client.end();
          return result.rows[0]
        })
      .catch(error => {
        await this.client.end();
        throw error.stack;
      });
  }
}
