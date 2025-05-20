const Habit = require("../models/Habit")


class HabitController {
    async create(request, response) {
        var {name, description, category_id, frequency, start_date, end_date, priority, reminders} = request.body 
        console.log(name)
        console.log(description)
        console.log(category_id)
        console.log(frequency)
        console.log(start_date)
        console.log(end_date)
        console.log(priority)
        console.log(reminders)
        if(name == undefined) {
            response.status(400)
            response.json({err: "nome invalido."})
            return
        }
        if(start_date == undefined) {
            response.status(400)
            response.json({err: "adicione uma data de inicio."})
            return
        }

        if(frequency == undefined) {
            response.status(400)
            response.json({err: "adicione a frequência do habito."})
            return
        }

        if (category_id === '' || category_id === undefined) {
            category_id = null;
        }   

        var valid = await Habit.findName(name) 
        if(valid) {
            response.status(406)
            response.json({err: "habito já existe."})
            return 
        }
        var done = await Habit.new(name, description, category_id, frequency, start_date, end_date, priority, reminders)
        if(done) {
            response.status(200)
            response.send('Cadastro realizado com sucesso.')
        }
        else {
            response.status(500)
            response.json({err: "erro ao cadastrar habito."})
        }
    }
}

module.exports = new HabitController()
