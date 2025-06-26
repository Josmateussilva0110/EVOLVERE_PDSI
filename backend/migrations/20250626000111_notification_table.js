const up = function(knex) {
    return knex.schema.createTable('notification', function(table) {
        table.increments('id');
        table.integer('user_id').unsigned().notNullable();
        table.json('data').nullable(); // Para armazenar lista com várias informações variadas
        table.timestamps(true, true);
        
        // Chave estrangeira para user_id
        table.foreign('user_id').references('id').inTable('users').onDelete('CASCADE');
    });
};

const down = function(knex) {
    return knex.schema.dropTable('notification');
};

module.exports = {
    up,
    down
};