const up = function(knex) {
    return knex.schema.alterTable('notification', function(table) {
        table.boolean('status').defaultTo(false).notNullable();
    });
};

const down = function(knex) {
    return knex.schema.alterTable('notification', function(table) {
        table.dropColumn('status');
    });
};

module.exports = {
    up,
    down
};