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

    async findAll() {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .select(
                'h.id',
                'h.name',
                'h.description',
                'c.name as categoria',
                'h.frequency',
                'h.start_date',
                'h.end_date',
                'h.priority',
                'h.reminders',
                'h.status',
            );

            const habits = result.map(habit => ({
            ...habit,
            reminders: Array.isArray(habit.reminders) ? habit.reminders : [],
            }));

            if(habits)
                return habits;
            else 
                return undefined;
        } catch (err) {
            console.error('Erro em findAll hábitos:', err);
            return undefined;
        }
    }


}

module.exports = new Habit()
