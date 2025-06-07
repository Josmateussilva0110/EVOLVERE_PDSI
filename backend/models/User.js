var knex = require("../database/connection")
var bcrypt = require("bcrypt")
const PasswordToken = require("./PasswordToken")

class User {

    async findAll() {
        try {
            var result = await knex.select(["id", "username", "email"]).table("users")
            return result
        } catch(err) {
            console.log('erro no findAll', err)
            return []
        }
    }


    async findById(id) {
        try {
            var result = await knex.select(["id", "username", "email", "created_at"]).where({id: id}).table("users")
            if(result.length > 0)
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById', err)
            return undefined
        }
    }

    async findByEmail(email) {
        try {
            var result = await knex.select(["id", "username", "email", "password"]).where({email: email}).table("users")
            if(result.length > 0) 
                return result[0]
            else
                return undefined
        } catch(err) {
            console.log('erro em findEmail', err)
            return undefined
        }
    }

    async new(username, email, password) {
        try {
            var hash = await bcrypt.hash(password, 8)
            await knex.insert({username, email, password: hash}).table("users")
            return true
        } catch(err) {
            console.log('erro ao cadastrar usuário', err)
            return false
        }
    }


    async findEmail(email) {
        try {
            var result = await knex.select("*").from("users").where({email: email})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log(err)
            return false
        }
        
    }

    async update(id, username, email) {
        const user = await this.findById(id);
        if (user) {
            const editUser = {};
            if (email && email !== user.email) {
                const emailExists = await this.findEmail(email);
                if (emailExists) {
                    return { status: false, err: "Email já existe" };
                }
                editUser.email = email;
            }
            if (username) {
                editUser.username = username;
            }

            try {
                await knex.update(editUser).where({ id }).table("users");
                return { status: true };
            } catch (err) {
                console.error("Erro ao atualizar usuário:", err);
                return { status: false, err };
            }
        } else {
            return { status: false, err: "Usuário não encontrado" };
        }
    }

   async delete(id) {
        var user = await this.findById(id) 
        if(user != undefined) {
            try {
                await knex.delete().where({id: id}).table("users")
                return {status: true}
            } catch(err) {
                return {status: false, err: err}
            }
        }
        else {
            return {status: false, err: 'usuário não existe.'}
        }
   }

   async changePassword(newPassword, id, token) {
        var hash = await bcrypt.hash(newPassword, 8)
        await knex.update({password: hash}).where({id: id}).table("users")
        await PasswordToken.setUsed(token)
   }

}

module.exports = new User()
