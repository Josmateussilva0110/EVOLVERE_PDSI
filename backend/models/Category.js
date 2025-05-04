var knex = require("../database/connection")

class Category {

    async findAll() {
        try {
            var result = await knex.select(["id", "name", "description", "color", "icon"]).table("category")
            return result
        } catch(err) {
            console.log('erro no findAll categoria', err)
            return []
        }
    }
  
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

    async findById(id) {
        try {
            var result = await knex.select(["id", "name", "description", "color", "icon"]).where({id: id}).table("category")
            if(result.length > 0)
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById categoria', err)
            return undefined
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
