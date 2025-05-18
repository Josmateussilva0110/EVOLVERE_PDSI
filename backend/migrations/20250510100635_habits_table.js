/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
  return knex.schema.createTable('habits', function(table) {
    table.increments('id');
    table.string('name', 150).notNullable();
    table.string('description', 255).nullable();
    table.integer('category_id').nullable();
    table.json('frequency').notNullable();
    table.date('start_date').notNullable();
    table.date('end_date').nullable();
    table.integer('priority').defaultTo(2);
    table.timestamps(true, true); // created_at e updated_at automáticos
  })
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
  return knex.schema.dropTable('habits');
};
