var knex = require("../database/connection")

class Category {

    async findCategoryName(name) {
        try {
            var result = await knex.select("*").from("category").where({name: name})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar categoria: ', err)
            return false
        }
        
    }

    async new(name, description, color, icon) {
        try {
            await knex.insert({name, description, color, icon}).table("category")
        } catch(err) {
            console.log('erro em adicionar categoria: ', err)
        }

    }

}

module.exports = new Category()
