const up = function(knex) {
    return knex.schema.createTable('habit_progress', function(table) {
        table.increments('id');
        table.integer('habit_id').unsigned().notNullable();
        table.foreign('habit_id').references('id').inTable('habits').onDelete('CASCADE').onUpdate('CASCADE');
        table.string('name', 100).notNullable();
        table.integer('type').notNullable();
        table.integer('parameter').nullable();
    })
};


const down = function(knex) {
  return knex.schema.dropTable('habit_progress');
};

module.exports = {
  up,
  down,
};

