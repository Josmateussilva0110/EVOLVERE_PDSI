const User = require("../models/User")
const PasswordToken = require("../models/PasswordToken")
const jwt = require("jsonwebtoken")
var bcrypt = require("bcrypt")


require('dotenv').config({ path: '../.env' })

class UserController {

    async index(request, response) {
        var users = await User.findAll()
        response.json(users)
    }

    async findUser(request, response) {
        var id = request.params.id
        if(!isNaN(id)) {
            var user = await User.findById(id)
            if(user != undefined) {
                response.status(200)
                response.json(user)
            }
            else {
                response.status(404)
                response.json({err: "Usuário não encontrado."})
            }
        }
        else 
        {
            response.status(400)
            response.json({err: "Id invalido"})
        }
    }

    async findEmailUser(request, response) {
        var email = request.params.email
        //console.log(email)
        if(email != undefined) {
            var emailUser = await User.findByEmail(email)
            if(emailUser != undefined){
                response.status(200)
                response.json(emailUser)
            }
            else {
                response.status(404)
                response.json({err: "Email não encontrado."})
            }
        }
        else {
            response.status(400)
            response.json({err: "Email invalido."})
        }
    }

    async create(request, response) {
        var {username, email, password} = request.body
        if(username == undefined) {
            response.status(400)
            response.json({err: "nome invalido."})
            return
        }

        if(email == undefined) {
            response.status(400)
            response.json({err: "email invalido."})
            return
        }

        if(password == undefined) {
            response.status(400)
            response.json({err: "senha invalido."})
            return
        }

        var valid = await User.findEmail(email)
        if(valid) {
            response.status(406)
            response.json({err: "email ja existe."})
            return 
        }

        var done = await User.new(username, email, password)
        if(done) {
            response.status(200)
            response.send('Cadastro realizado com sucesso.')
        }
        else {
            response.status(500)
            response.json({err: "erro ao cadastrar usuário."})
        }
    }

    async edit(request, response) {
        var {id, username, email} = request.body
        if(id == undefined) {
            response.status(400)
            response.json({err: "usuário invalido."})
            return
        }

        if(username == undefined) {
            response.status(400)
            response.json({err: "nome invalido."})
            return
        }

        if(email == undefined) {
            response.status(400)
            response.json({err: "email invalido."})
            return
        }

        var result = await User.update(id, username, email)
        if(result != undefined) {
            if(result.status) {
                response.status(200)
                response.send('dados do usuário atualizado.')
            }
            else {
                response.status(406)
                response.send(result.err)
            }
        }
        else {
            response.status(406)
            response.json({err: "erro ao atualizar usuário."})
        }
    }

    async remove(request, response) {
        var id = request.params.id
        var result = await User.delete(id)
        if(result.status) {
            response.status(200)
            response.send('usuário removido com sucesso.')
        }
        else {
            response.status(406)
            response.send(result.err)
        }
    }

    async recoverPassword(request, response) {
        var email = request.body.email
        if(email != undefined) {
            var result = await PasswordToken.create(email)
            if(result.status) {
                response.status(200)
                response.send("" + result.token)
            }
            else {
                response.status(406)
                response.send(result.err)
            }
        }
    }

    async changePassword(request, response) {
        var token = request.body.token
        var password = request.body.password
        var istokenValid = await PasswordToken.validate(token)
        if(istokenValid.status) {
            await User.changePassword(password, istokenValid.token.user_id, istokenValid.token.token)
            response.status(200)
            response.send('alterado com sucesso.')
        }
        else {
            response.status(406)
            response.json({err: "token invalido."})
        }
   }

   async login(request, response) {
        var {email, password} = request.body
        var user = await User.findByEmail(email)
        if(user != undefined) {
            var valid = await bcrypt.compare(password, user.password)
            if(valid) {
                var token = jwt.sign({email: user.email}, process.env.SECRET)
                response.status(200)
                response.json({token: token, userId: user.id})
            }
            else {
                response.status(406)
                response.json({err: 'Senha invalida.'})
            }
        }
        else {
            response.status(406)
            response.json({err: 'Usuário não encontrado.'})
        }
   }

   async editProfile(request, response) {
        const userId = request.params.id;
        const { username, email } = request.body;

        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "ID inválido" });
        }

        if (!username || username.trim() === "") {
            return response.status(400).json({ err: "Nome de usuário inválido" });
        }

        if (!email || email.trim() === "") {
            return response.status(400).json({ err: "Email inválido" });
        }

        try {
            const user = await User.findById(userId);
            if (!user) {
                return response.status(404).json({ err: "Usuário não encontrado" });
            }

            const result = await User.update(userId, username, email);
            if (result.status) {
                response.status(200).json({ message: "Perfil atualizado com sucesso" });
            } else {
                response.status(406).json({ err: result.err });
            }
        } catch (error) {
            console.error("Erro ao atualizar perfil:", error);
            response.status(500).json({ err: "Erro interno ao atualizar perfil" });
        }
    }

    async getLoggedUserInfo(request, response) {
        const userId = request.params.id;

        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "ID inválido" });
        }

        try {
            const user = await User.findById(userId);
            if (!user) {
                return response.status(404).json({ err: "Usuário não encontrado" });
            }

            // Formata a data de criação
            const createdAt = new Date(user.created_at);
            const formattedDate = createdAt.toLocaleDateString('pt-BR', {
                month: 'long',
                year: 'numeric'
            });

            response.status(200).json({
                name: user.username,
                email: user.email,
                createdAt: formattedDate
            });
        } catch (error) {
            console.error("Erro ao buscar informações do usuário:", error);
            response.status(500).json({ err: "Erro interno ao buscar informações do usuário" });
        }
    }
}

module.exports = new UserController()
