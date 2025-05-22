var knex = require("../database/connection")

class Habit {

    async findName(name) {
        try {
            var result = await knex.select("*").from("habits").where({name: name})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar nome do habito: ', err)
            return false
        }
    }

    async new(name, description, category_id, frequency, start_date, end_date, priority, reminders) {
        try {
            await knex.insert({name, description, category_id, frequency, start_date, end_date, priority, reminders: reminders ? JSON.stringify(reminders) : null}).table("habits")
            return true
        } catch(err) {
            console.log('erro em cadastrar habito: ', err)
            return false
        }
    }
}

module.exports = new Habit()
