const up = function(knex) {
  return knex.schema.alterTable('category', function(table) {
    table.integer('user_id').unsigned().notNullable()
      .references('id')
      .inTable('users')
      .onDelete('CASCADE')
      .onUpdate('CASCADE');
  });
};

const down = function(knex) {
  return knex.schema.alterTable('category', function(table) {
    table.dropForeign(['user_id']);
    table.dropColumn('user_id');
  });
};

module.exports = {
  up,
  down,
};
