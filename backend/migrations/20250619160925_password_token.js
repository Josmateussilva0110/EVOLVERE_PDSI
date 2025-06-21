const up = function(knex) {
    return knex.schema.createTable('passwordToken', function(table) {
        table.increments('id');
        table.string('token', 200).notNullable();
        table.integer('user_id').unsigned().notNullable();
        table.foreign('user_id').references('id').inTable('users').onDelete('CASCADE').onUpdate('CASCADE');
        table.integer('used').defaultTo(0);
    })
};


const down = function(knex) {
  return knex.schema.dropTable('passwordToken');
};

module.exports = {
  up,
  down,
};
