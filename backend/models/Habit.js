var knex = require("../database/connection")
const formatDateForMySQL = require("../utils/format_date")




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

    async habitExist(id) {
        try {
            var result = await knex.select(["id"]).from("habits").where({id: id})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar id do habito: ', err)
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
    async findNotArchived() {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .where('h.status', '!=', 3)
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

    async findArchived() {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .where('h.status', '=', 3)
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

    async findById(id) {
        try {
            var result = await knex.select(["id", "name", "description", "category_id", "frequency", "start_date", "end_date", "priority", "reminders", "status"]).where({id: id}).table("habits")
            if(result.length > 0) 
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById', err)
            return undefined
        }
    }
    async findByName(name) {
        try {
            var result = await knex.select(["id", "name", "description", "category_id", "frequency", "start_date", "end_date", "priority", "reminders", "status"]).where({name: name}).table("habits")
            if(result.length > 0) 
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById', err)
            return undefined
        }
    }
    async delete(id) {
        try {
            await knex("habits").where({id: id}).del()
            return true
        } catch(err) {
            console.log('erro ao deletar habito: ', err)
            return false
        }
    }

    async archive(id) {
        try {
            await knex("habits").where({id: id}).update({status: 3})
            return true
        } catch(err) {
            console.log('erro ao arquivar habito: ', err)
            return false
        }
    }

    async updateToActive(id) {
        try {
            await knex("habits").where({id: id}).update({status: 1})
            return true
        } catch(err) {
            console.log('erro ao arquivar habito: ', err)
            return false
        }
    }
    async uptadeData(id, name, description, category_id, frequency, start_date, end_date, priority, reminders) {
        try {
            const updates = {
                name,
                description,
                category_id,
                frequency: frequency ? JSON.stringify(frequency) : undefined,
                start_date: start_date ? formatDateForMySQL(start_date) : undefined,
                end_date: end_date ? formatDateForMySQL(end_date) : undefined,
                priority,
                reminders: reminders ? JSON.stringify(reminders) : undefined,
                updated_at: knex.fn.now()
            }

            // Remove valor undefined ou null
            Object.keys(updates).forEach(key => {
                if (updates[key] === undefined) {
                    delete updates[key]
                }
            })
            await knex.table("habits").where({ id }).update(updates)
            return true
        } catch (err) {
            console.log('erro em editar habito: ', err)
            return false
        }
    }
}

module.exports = new Habit()
