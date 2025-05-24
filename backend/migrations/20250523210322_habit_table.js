const up = function(knex) {
  return knex.schema.createTable('habits', function(table) {
    table.increments('id');
    table.string('name', 150).notNullable();
    table.string('description', 255).nullable();
    table.integer('category_id').nullable();
    table.json('frequency').notNullable();
    table.date('start_date').notNullable();
    table.date('end_date').nullable();
    table.integer('priority').defaultTo(2);
    table.json('reminders').nullable();
    table.integer('status').defaultTo(1); // 1 = ativo 2 = cancelado 3 = arquivado 4 = concluído
    table.timestamps(true, true); // created_at e updated_at automáticos
  })
};


const down = function(knex) {
  return knex.schema.dropTable('habits');
};

module.exports = {
  up,
  down
};
