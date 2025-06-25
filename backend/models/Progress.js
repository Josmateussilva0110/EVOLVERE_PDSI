var knex = require("../database/connection")

class Progress {
    async findNameProgress(name) {
        try {
            var result = await knex.select("*").from("habit_progress").where({name: name})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar nome do progresso habito: ', err)
            return false
        }
    }

    async newHabitProgress(habit_id, name, type, parameter) {
        try {
            await knex.insert({habit_id, name, type, parameter}).table("habit_progress")
            return true
        } catch(err) {
            console.log('erro ao cadastrar progresso do habito: ', err)
            return false
        }
    }

    async getAllProgressHabits(habit_id) {
        try {
            const result = await knex.raw(`
                SELECT 
                    id, 
                    habit_id, 
                    name, 
                    parameter,
                    type,
                    CASE 
                        WHEN type = 0 THEN 'automático'
                        WHEN type = 1 THEN 'manual'
                        WHEN type = 2 THEN 'acumulativa'
                        ELSE 'desconhecido'
                    END AS type_description
                FROM habit_progress 
                WHERE habit_id = ? and status = 1
            `, [habit_id]);

            const rows = result[0]

            if(rows.length > 0) {
                return rows
            }
            else {
                return undefined
            }
        } catch(err) {
            console.log('erro em buscar progressos do habito.', err)
            return undefined
        }
    }

    async progressExists(id) {
        try {
            var result = await knex.select(["id"]).from("habit_progress").where({id: id})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar id do progresso: ', err)
            return false
        }
    }

    async delete(id) {
        try {
            await knex("habit_progress").where({id: id}).del()
            return true
        } catch(err) {
            console.log('erro ao deletar habito: ', err)
            return false
        }
    }

    async complete(id) {
        try {
            await knex("habit_progress").where({id: id}).update({status: 2})
            return true
        } catch(err) {
            console.log('erro ao completar habito: ', err)
            return false
        }
    }

    async cancel(id) {
        try {
            await knex("habit_progress").where({id: id}).update({status: 0})
            return true
        } catch(err) {
            console.log('erro ao cancelar progresso: ', err)
            return false
        }
    }
}

module.exports = new Progress()
