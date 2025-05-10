/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
  return knex.schema.createTable('habits', function(table) {
    table.increments('id');
    table.string('name', 100).notNullable();
    table.string('description', 255).nullable();
    table.integer('category_id').notNullable();



  })
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
  return knex.schema.dropTable('habits');
};
