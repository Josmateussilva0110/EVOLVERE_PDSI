var knex = require("../database/connection")
const { v4: uuidv4 } = require("uuid")

class PasswordToken {
    async create(user_id) {
        const token = uuidv4() 
        try {
            await knex.insert({
                user_id: user_id,
                used: 0,
                token: token
            }).table("passwordToken")
            return { token }
        } catch(err) {
            console.error("Erro ao criar token:", err)
            return false
        }
    }


    async validate(token) {
        try {
           var result = await knex.raw(`
            select token, user_id from passwordToken
            where token = ? and used = '0';
            `, [token])
            if(result[0].length > 0) {
                var tk = result[0]
                if(tk.used) {
                    return undefined
                }
                else {
                    return tk[0]
                }
            }
            else 
                return undefined
        } catch(err) {
            return undefined
        }
    }


    async setUsed(token) {
        await knex.update({used: 1}).where({token: token}).table("passwordToken")
    }
}


module.exports = new PasswordToken()
