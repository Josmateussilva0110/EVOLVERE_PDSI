const up = function(knex) {
    return knex.schema.createTable('category', function(table) {
        table.increments('id');
        table.string('name', 100).notNullable();
        table.string('description', 255).nullable();
        table.string('color', 100).nullable();
        table.string('icon', 100).nullable();
        table.timestamps(true, true);
    });
};

const down = function(knex) {
    return knex.schema.dropTable('category');
};

module.exports = {
    up,
    down
};