const up = function(knex) {
    return knex.schema.alterTable('users', function(table) {
      table.string('upload_perfil').nullable();
    });
  };
  
  const down = function(knex) {
    return knex.schema.alterTable('users', function(table) {
      table.dropColumn('upload_perfil');
    });
  };
  
  module.exports = {
    up,
    down,
  }; 