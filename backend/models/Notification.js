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
}

module.exports = new Notification() 