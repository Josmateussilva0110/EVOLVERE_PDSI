const Habit = require("../models/Habit")


class HabitController {
    async create(request, response) {
        var {name, description, category_id, frequency, start_date, end_date, priority, reminders} = request.body 
        if (!name || name.trim() === '') { //debug trim() remove os espaços em branco do incio e fim da string
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
            response.json({err: "adicione a frequência do hábito."})
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

    async getAllHabits(request, response) {
        const habits = await Habit.findAll()

        if (habits && habits.length > 0) {
            response.status(200).json({ habits })
        } else {
            response.status(404).json({ err: "Nenhum hábito encontrado." })
        }
    }

    async getHabitsNotArchived(request, response) {
        const habits = await Habit.findNotArchived()

        if (habits && habits.length > 0) {
            response.status(200).json({ habits })
        } else {
            response.status(404).json({ err: "Nenhum hábito encontrado." })
        }
    }



    async remove(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" });
        }
        const habit = await Habit.findById(id)
        if(!habit) {
            return response.status(404).json({ err: "habito não encontrada" });
        }
        var result = await Habit.delete(id)
        if(result) {
            response.status(200)
            response.json({message: "Habito removido com sucesso."})
        }
        else {
            response.status(500).json({ err: "Erro ao excluir habito."});
        }
    }

    async archiveHabit(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" });
        }
        const habit = await Habit.habitExist(id)
        if(!habit) {
            return response.status(404).json({ err: "habito não encontrada" });
        }
        var result = await Habit.archive(id)
        if(result) {
            response.status(200)
            response.json({message: "Habito arquivado com sucesso."})
        }
        else {
            response.status(500)
            response.json({err: "Erro ao arquivar habito."})
        }
    }

    async setHabitToActive(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" });
        }
        const habit = await Habit.habitExist(id)
        if(!habit) {
            return response.status(404).json({ err: "habito não encontrada" });
        }
        var result = await Habit.updateToActive(id)
        if(result) {
            response.status(200)
            response.json({message: "Habito atualizado para ativo."})
        }
        else {
            response.status(500)
            response.json({err: "Erro ao atualizar habito para ativo."})
        }
    }

}

module.exports = new HabitController()
