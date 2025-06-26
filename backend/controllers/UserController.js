const User = require("../models/User")
const PasswordToken = require("../models/PasswordToken")
const jwt = require("jsonwebtoken")
var bcrypt = require("bcrypt")
const sendEmail = require("../utils/send_email")
const formatMessageSendPassword = require("../utils/message_email")
const path = require('path')



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
                response.json({token: token, userId: user.id, username: user.username, email: user.email})
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
                createdAt: formattedDate,
                upload_perfil: user.upload_perfil || null
            });
        } catch (error) {
            console.error("Erro ao buscar informações do usuário:", error);
            response.status(500).json({ err: "Erro interno ao buscar informações do usuário" });
        }
    }

    async editUsername(request, response) {
        const userId = request.params.id;
        const { username } = request.body;

        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "ID inválido" });
        }

        if (!username || username.trim() === "") {
            return response.status(400).json({ err: "Nome de usuário inválido" });
        }

        try {
            const user = await User.findById(userId);
            if (!user) {
                return response.status(404).json({ err: "Usuário não encontrado" });
            }

            const result = await User.updateUsername(userId, username)
            if (result.status) {
                response.status(200).json({ message: "Nome atualizado com sucesso" });
            } else {
                response.status(406).json({ err: result.err });
            }
        } catch (error) {
            console.error("Erro ao atualizar perfil:", error);
            response.status(500).json({ err: "Erro interno ao atualizar perfil" });
        }
    }

    async editEmail(request, response) {
        const userId = request.params.id;
        const { email } = request.body;

        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "ID inválido" });
        }

        if (!email || email.trim() === "") {
            return response.status(400).json({ err: "Email de usuário inválido" });
        }

        try {
            const user = await User.findById(userId);
            if (!user) {
                return response.status(404).json({ err: "Usuário não encontrado" });
            }

            const result = await User.updateEmail(userId, email)
            if (result.status) {
                response.status(200).json({ message: "Email atualizado com sucesso" });
            } else {
                response.status(406).json({ err: result.err });
            }
        } catch (error) {
            console.error("Erro ao atualizar perfil:", error);
            response.status(500).json({ err: "Erro interno ao atualizar email" });
        }
    }

    
    async send_token(request, response) {
        const { email } = request.body;

        const user = await User.findByEmail(email);
        if (!user) {
            return response.status(404).json({ error: "Usuário não encontrado" });
        }

        const code = Math.floor(1000 + Math.random() * 9000); 

        const token = jwt.sign(
            { email, code },
            process.env.SECRET,
            { expiresIn: '3m' }
        );

        const subject = "Redefinição de Senha - Evolvere";
        const { html } = formatMessageSendPassword(code, user.username);
        await sendEmail(email, subject, html);

        return response.json({
            success: true,
            message: "Verifique seu email",
            token, 
        });
    }

    async verify_code(request, response) {
        const { token, code } = request.body;

        try {
            const decoded = jwt.verify(token, process.env.SECRET);

            if (decoded.code.toString() === code.toString()) {
                return response.json({ success: true, message: "Código validado com sucesso" });
            } else {
                return response.status(400).json({ error: "Código inválido" });
            }
        } catch (error) {
            return response.status(400).json({ error: "Token inválido ou expirado" });
        }
    }

    async reset_password(request, response) {
        const { token, password } = request.body
        try {
            const decoded = jwt.verify(token, process.env.SECRET)
            const user = await User.findByEmail(decoded.email)
            if (!user) {
                return response.status(404).json({ error: "Usuário não encontrado" })
            }
            const hashedPassword = await bcrypt.hash(password, 10)
            const done = await User.updatePassword(user.id, hashedPassword)
            if(done) {
                return response.json({ success: true, message: "Senha atualizada com sucesso" })
            }
            else {
                return response.status(500).json({ error: "Erro ao salvar nova senha." })
            }
        } catch (error) {
            return response.status(400).json({ error: "Token inválido ou expirado" })
        }
    }

    async uploadProfileImage(request, response) {
        const userId = request.params.id;
        
        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "ID inválido" });
        }

        try {
            const user = await User.findById(userId);
            if (!user) {
                return response.status(404).json({ err: "Usuário não encontrado" });
            }

            let imagePath = null;

            if (request.files && request.files.profile_image) {
                const imageFile = request.files.profile_image;
        
                if (imageFile.size > 5 * 1024 * 1024) {
                    return response.status(400).json({ err: "A imagem deve ter no máximo 5MB!" });
                }
        
                const fileName = Date.now() + path.extname(imageFile.name);
                const uploadPath = path.join(__dirname, "..", "public", "user_profile_images", fileName);
        
                try {
                    await imageFile.mv(uploadPath);
                    imagePath = "/user_profile_images/" + fileName; 
                } catch (err) {
                    console.error("Erro ao salvar a imagem:", err);
                    return response.status(500).json({ err: "Erro ao salvar a imagem." });
                }
            } else {
                return response.status(400).json({ err: "Nenhuma imagem foi enviada." });
            }

            const result = await User.updateProfileImage(userId, imagePath);
            if (result.status) {
                response.status(200).json({ 
                    message: "Imagem de perfil atualizada com sucesso",
                    imagePath: imagePath 
                });
            } else {
                response.status(406).json({ err: result.err });
            }
        } catch (error) {
            console.error("Erro ao atualizar imagem de perfil:", error);
            response.status(500).json({ err: "Erro interno ao atualizar imagem de perfil" });
        }
    }
}
module.exports = new UserController()
