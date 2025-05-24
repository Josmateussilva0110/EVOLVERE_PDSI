const up = function(knex) {
  return knex.schema.alterTable('habits', function(table) {
    table.integer('category_id').unsigned().nullable().alter();
    table.foreign('category_id').references('id').inTable('category').onDelete('SET NULL').onUpdate('CASCADE');
  });
};

const down = function(knex) {
  return knex.schema.alterTable('habits', function(table) {
    table.dropForeign('category_id');
    table.integer('category_id').nullable().alter();
  });
};

module.exports = {
  up,
  down,
};
