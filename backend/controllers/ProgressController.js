const Progress = require("../models/Progress")
const Habit = require("../models/Habit")

class ProgressController {
    async habitProgressCreate(request, response) {
        var {habit_id, name, type, parameter} = request.body
        habit_id = Number(habit_id)
        type = Number(type)
        parameter = Number(parameter)
        if (!name || name.trim() === '') { 
            response.status(400)
            response.json({err: "nome invalido."})
            return
        }
        if (isNaN(habit_id)) {
            return response.status(400).json({ err: "Hábito invalido." })
        }

        if (isNaN(type)) {
            return response.status(400).json({ err: "Tipo invalido." })
        }

        if (isNaN(parameter)) {
            return response.status(400).json({ err: "Parâmetro invalido." })
        }

        var valid = await Habit.findById(habit_id)
        if(!valid) {
            response.status(404)
            response.json({err: "Nenhum habito encontrado."})
            return 
        }
        var nameExists = await Progress.findNameByIdUser(name, valid.user_id)
        if(nameExists) {
            return response.status(406).json({err: "nome de progresso ja existe."})
        }
        var done = await Progress.newHabitProgress(habit_id, name, type, parameter)
        if(done) {
            response.status(200)
            response.send('Progresso de habito adicionado com sucesso.')
        }
        else {
            response.status(500)
            response.json({err: "erro ao cadastrar progresso de habito."})
        }
    }

    async getHabitsProgress(request, response) {
        const habit_id = request.params.habit_id
        if (!habit_id || isNaN(habit_id)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }

        try {
            const habit_progress = await Progress.getAllProgressHabits(habit_id)
            if(habit_progress != undefined) {
                response.status(200).json({habit_progress: habit_progress})
            }
            else {
                response.status(404).json({ err: "progressos não encontrados."})
            }
        } catch(err) {
            response.status(500).json({ err: "Erro ao buscar progresso de habitos."})
        }
    }

    async removeProgress(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }

        try {
            const progress = await Progress.progressExists(id)
            if(!progress) {
                return response.status(404).json({err: "progresso não encontrado."})
            }
            var result = await Progress.delete(id)
            if(result) {
                response.status(200).json({message: "Progresso removido com sucesso."})
            }
            else {
                response.status(500).json({err: "Erro ao remover progresso"})
            }

        } catch(err) {
            response.status(500).json({ err: "falha ao remover progresso."})
        }
    }

    async completeProgress(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" });
        }
        const progress = await Progress.progressExists(id)
        if(!progress) {
            return response.status(404).json({ err: "progresso não encontrado" });
        }
        var result = await Progress.complete(id)
        if(result) {
            response.status(200)
            response.json({message: "progresso concluído com sucesso."})
        }
        else {
            response.status(500)
            response.json({err: "Erro ao concluir progresso."})
        }
    }

    async cancelProgress(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" });
        }
        const progress = await Progress.progressExists(id)
        if(!progress) {
            return response.status(404).json({ err: "progresso não encontrado" });
        }
        var result = await Progress.cancel(id)
        if(result) {
            response.status(200)
            response.json({message: "progresso cancelado."})
        }
        else {
            response.status(500)
            response.json({err: "Erro ao cancelar progresso."})
        }
    }

    async editProgress(request, response) {
        const id = request.params.id
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" });
        }

        var {name, type, parameter} = request.body
        type = Number(type)
        parameter = Number(parameter)
        if (!name || name.trim() === '') { 
            response.status(400)
            response.json({err: "nome invalido."})
            return
        }

        if (isNaN(type)) {
            return response.status(400).json({ err: "Tipo invalido." })
        }

        if (isNaN(parameter)) {
            return response.status(400).json({ err: "Parâmetro invalido." })
        }

        var nameExists = await Progress.findNameProgress(name)
        if(nameExists) {
            return response.status(406).json({err: "nome de progresso ja existe."})
        }
        var done = await Progress.update(id, name, type, parameter)
        if(done) {
            response.status(200)
            response.send('Progresso editado com sucesso.')
        }
        else {
            response.status(500)
            response.json({err: "erro ao editar progresso de habito."})
        }
    }

}

module.exports = new ProgressController()
