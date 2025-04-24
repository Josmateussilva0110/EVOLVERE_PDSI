const User = require("../models/User")
const PasswordToken = require("../models/PasswordToken")
const jwt = require("jsonwebtoken")
var bcrypt = require("bcrypt")


var secret = "fjskhfrjkgjrhdkfjklnlashdjhjdfsbdfnbmsfbrfndbndbsmoiwwq"

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
                response.send('Usuário não encontrado.')
            }
        }
        else 
        {
            response.status(400)
            response.send('Id invalido.')
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
                response.send("email não encontrado.")
            }
        }
        else {
            response.status(400)
            response.send("email invalido")
        }
    }

    async create(request, response) {
        var {name, email, password} = request.body
        if(email == undefined) {
            response.status(400)
            response.json({err: "email invalido."})
            return
        }

        var valid = await User.findEmail(email)
        if(valid) {
            response.status(406)
            response.json({err: "email ja existe."})
            return 
        }

        await User.new(name, email, password)
        response.status(200)
        response.send('Sem erro.')
    }

    async edit(request, response) {
        var {id, name, email, role} = request.body
        var result = await User.update(id, name, email, role)
        if(result != undefined) {
            if(result.status) {
                response.status(200)
                response.send('atualizado.')
            }
            else {
                response.status(406)
                response.send(result.err)
            }
        }
        else {
            response.status(406)
            response.send('erro ao atualizar.')
        }

    }

    async remove(request, response) {
        var id = request.params.id
        var result = await User.delete(id)
        if(result.status) {
            response.status(200)
            response.send('removido com sucesso.')
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
            response.send('token invalido.')
        }
   }

   async login(request, response) {
        var {email, password} = request.body
        var user = await User.findByEmail(email)
        if(user != undefined) {
            var valid = await bcrypt.compare(password, user.password)
            if(valid) {
                var token = jwt.sign({email: user.email, role: user.role}, secret)
                response.status(200)
                response.json({token: token})
            }
            else {
                response.status(406)
                response.send('Senha incorreta.')
            }
        }
        else {
            response.json({status: false})
        }
   }
}

module.exports = new UserController()
