/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
    return knex.schema.createTable('users', function(table) {
      table.increments('id'); 
      table.string('username', 100).notNullable();
      table.string('email', 100).notNullable().unique();
      table.string('password', 255).notNullable();
      table.boolean('premium').defaultTo(false);
      table.timestamps(true, true); // created_at e updated_at automáticos
    });
  };
  
  /**
   * @param { import("knex").Knex } knex
   * @returns { Promise<void> }
   */
  exports.down = function(knex) {
    return knex.schema.dropTable('users');
  };
  