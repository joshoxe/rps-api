const DataContext = require('./context/data-context');

modules.exports = class Repository {
  /**
   * Generic abstract CRUD repository for database operations.
   */
  constructor() {
    if (new.target === Repository) {
      throw 'Cannot construct instances of abstract Repository';
    }
    this.table = '';
    this.dataContext = new DataContext();
  }

  /**
   * Retrieve an item from a data source via ID
   * @param {number} id ID of the item to retrieve
   * @returns Returns an item, depending on the table.
   */
  async get(id) {
    const query = {
      text: 'SELECT * FROM $1 WHERE id = $2;',
      values: [this.table, id],
    };

    return this.dataContext.query(query);
  }

  async getAll() {
    const query = {
      text: 'SELECT * FROM $1;',
      values: [this.table],
    };

    return this.dataContext.query(query);
  }

  async delete(id) {
    const query = {
      text: 'DELETE FROM $1 WHERE id = $2;',
      values: [this.table, id],
    };

    return this.dataContext.query(query);
  }

  async deleteRange(ids) {
    ids.forEach(id => {
      await this.delete(id);
    });
  }
}
