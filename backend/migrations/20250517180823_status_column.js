const up = function(knex) {
    return knex.schema.alterTable('category', function(table) {
        table.boolean('archived').defaultTo(false).notNullable();
    });
};

const down = function(knex) {
    return knex.schema.alterTable('category', function(table) {
        table.dropColumn('archived');
    });
};

module.exports = {
    up,
    down
};