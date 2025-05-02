// Update with your config settings.
require('dotenv').config({ path: '../.env' });

/**
 * @type { Object.<string, import("knex").Knex.Config> }
 */
module.exports = {
  development: {
    client: 'mysql2',
    connection: {
      host: process.env.HOST,
      user: process.env.USER,
      password: process.env.PASSWORD,
      database: process.env.DATABASE
    },
    migrations: {
      tableName: 'knex_migrations',
      directory: './migrations'
    }
  }
};

