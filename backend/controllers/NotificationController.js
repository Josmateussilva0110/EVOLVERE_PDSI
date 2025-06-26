const Notification = require("../models/Notification")

class NotificationController {

    async index(request, response) {
        var notifications = await Notification.findAll()
        response.json(notifications)
    }

    async findById(request, response) {
        var id = request.params.id
        if(!isNaN(id)) {
            var notification = await Notification.findById(id)
            if(notification != undefined) {
                response.status(200)
                response.json(notification)
            }
            else {
                response.status(404)
                response.json({err: "Notificação não encontrada."})
            }
        }
        else 
        {
            response.status(400)
            response.json({err: "Id invalido"})
        }
    }

    async findByUserId(request, response) {
        var userId = request.params.userId
        if(!isNaN(userId)) {
            var notifications = await Notification.findByUserId(userId)
            response.status(200)
            response.json(notifications)
        }
        else 
        {
            response.status(400)
            response.json({err: "Id do usuário invalido"})
        }
    }

    async create(request, response) {
        var {user_id, data} = request.body
        if(user_id == undefined) {
            response.status(400)
            response.json({err: "user_id invalido."})
            return
        }

        if(data == undefined) {
            response.status(400)
            response.json({err: "data invalida."})
            return
        }

        var done = await Notification.create(user_id, data)
        if(done) {
            response.status(200)
            response.send('Notificação criada com sucesso.')
        }
        else {
            response.status(500)
            response.json({err: "erro ao criar notificação."})
        }
    }

    async remove(request, response) {
        var id = request.params.id
        var result = await Notification.delete(id)
        if(result.status) {
            response.status(200)
            response.send('notificação removida com sucesso.')
        }
        else {
            response.status(406)
            response.send(result.err)
        }
    }

    async removeByUserId(request, response) {
        var userId = request.params.userId
        var result = await Notification.deleteByUserId(userId)
        if(result.status) {
            response.status(200)
            response.send('notificações do usuário removidas com sucesso.')
        }
        else {
            response.status(406)
            response.send(result.err)
        }
    }
}

module.exports = new NotificationController() 