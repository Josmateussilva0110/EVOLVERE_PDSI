const up = function(knex) {
    return knex.schema.createTable('finish_habit', function(table) {
        table.increments('id');
        table.integer('habit_id').unsigned().notNullable();
        table.foreign('habit_id').references('id').inTable('habits').onDelete('CASCADE').onUpdate('CASCADE');
        table.integer('difficulty').notNullable();
        table.integer('mood').notNullable();
        table.string('reflection', 255).nullable();
        table.string('location', 255).nullable();
        table.time('hour').notNullable();
    })
};


const down = function(knex) {
  return knex.schema.dropTable('finish_habit');
};

module.exports = {
  up,
  down,
};

