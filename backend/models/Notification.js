var knex = require("../database/connection")

class Notification {

    async findAll() {
        try {
            var result = await knex.select("*").table("notification")
            return result
        } catch(err) {
            console.log('erro no findAll', err)
            return []
        }
    }

    async findById(id) {
        try {
            var result = await knex.select("*").where({id: id}).table("notification")
            if(result.length > 0)
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById', err)
            return undefined
        }
    }

    async findByUserId(userId) {
        try {
            var result = await knex.select("*").where({user_id: userId}).orderBy('created_at', 'desc').table("notification")
            return result
        } catch(err) {
            console.log('erro no findByUserId', err)
            return []
        }
    }

    async create(userId, data) {
        try {
            await knex.insert({user_id: userId, data: data}).table("notification")
            return true
        } catch(err) {
            console.log('erro ao criar notificação', err)
            return false
        }
    }

    async delete(id) {
        var notification = await this.findById(id) 
        if(notification != undefined) {
            try {
                await knex.delete().where({id: id}).table("notification")
                return {status: true}
            } catch(err) {
                return {status: false, err: err}
            }
        }
        else {
            return {status: false, err: 'notificação não existe.'}
        }
    }

    async deleteByUserId(userId) {
        try {
            await knex.delete().where({user_id: userId}).table("notification")
            return {status: true}
        } catch(err) {
            return {status: false, err: err}
        }
    }

    async updateStatus(id, status) {
        try {
            await knex.update({status: status}).where({id: id}).table("notification")
            return {status: true}
        } catch(err) {
            console.log('erro ao atualizar status da notificação', err)
            return {status: false, err: err}
        }
    }

    async countReadByUserId(userId) {
        try {
            const result = await knex('notification')
                .where({ user_id: userId, status: true })
                .count('id as count');
            return parseInt(result[0].count, 10) || 0;
        } catch (err) {
            return 0;
        }
    }

    async countUnreadByUserId(userId) {
        try {
            const result = await knex('notification')
                .where({ user_id: userId, status: false })
                .count('id as count');
            return parseInt(result[0].count, 10) || 0;
        } catch (err) {
            return 0;
        }
    }

    async findByHabitIdAndDateRange(habitId, startDate, endDate) {
        try {
            const result = await knex('notification')
                .whereRaw('JSON_EXTRACT(data, "$.habitId") = ?', [habitId.toString()])
                .whereBetween('created_at', [startDate, endDate])
                .select('*');
            return result;
        } catch (err) {
            console.log('erro no findByHabitIdAndDateRange', err);
            return [];
        }
    }
}

module.exports = new Notification() 