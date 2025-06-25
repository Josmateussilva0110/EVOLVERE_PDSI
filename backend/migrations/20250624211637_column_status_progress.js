const up = function(knex) {
    return knex.schema.alterTable('habit_progress', function(table) {
        table.integer('status').defaultTo(1).notNullable(); // 0 = falhou 1 = ativo 2 = concluiu 
    });
};

const down = function(knex) {
    return knex.schema.alterTable('habit_progress', function(table) {
        table.dropColumn('status');
    });
};

module.exports = {
    up,
    down
};
