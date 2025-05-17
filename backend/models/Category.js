var knex = require("../database/connection")

class Category {

    async findAll() {
        try {
            const result = await knex.select([
                "id",
                "name",
                "description",
                "color",
                "icon"
            ]).where('archived', false).from("category");
            var result = await knex
                .select(["id", "name", "description", "color", "icon"])
                .from("category") 
            return result;
        } catch(err) {
            console.log(err);
            return [];
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
            return true
        } catch(err) {
            console.log('erro em adicionar categoria: ', err)
            return false
        }
    }
    async delete(id) {
        try {
            await knex("category").where({ id: id }).del();
            return true;
        } catch (err) {
            console.log("erro ao deletar categoria", err);
            return false;
        }
    }

    async archive(id) {
        try {
            await knex("category")
                .where({ id: id })
                .update({ archived: true });
            return true;
        } catch (err) {
            console.log("erro ao arquivar categoria", err);
            return false;
        }
    }

    async findArchived() {
        try {
            const result = await knex.select([
                "id",
                "name",
                "description",
                "color",
                "icon"
            ]).where('archived', true).from("category");
            return result;
        } catch(err) {
            console.log(err);
            return [];
        }
    }

    async unarchive(id) {
        try {
            await knex("category")
                .where({ id: id })
                .update({ archived: false });
            return true;
        } catch (err) {
            console.log("erro ao restaurar categoria", err);
            return false;
        }
    }

    async update(id, name, description, color, icon) {
        try {
            const updateData = { name, description, color };
            if (icon !== undefined) {
                updateData.icon = icon;
            }
            await knex("category")
                .where({ id: id })
                .update(updateData);
            return true;
        } catch (err) {
            console.log("erro ao atualizar categoria", err);
            return false;
        }
    }
}

module.exports = new Category()
