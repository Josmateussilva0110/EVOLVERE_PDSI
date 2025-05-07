/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
    return knex.schema.createTable('category', function(table) {
        table.increments('id'); 
        table.string('name', 100).notNullable();
        table.string('description', 255).nullable();
        table.string('color', 100).nullable();
        table.string('icon', 100).nullable();
        table.timestamps(true, true); // created_at e updated_at automáticos
    });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
    return knex.schema.dropTable('category');
};
