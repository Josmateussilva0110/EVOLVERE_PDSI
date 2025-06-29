const Habit = require("../models/Habit")
const Notification = require("../models/Notification")


class HabitController {
    async create(request, response) {
        var {name, description, category_id, frequency, start_date, end_date, priority, reminders, user_id} = request.body 
        if (!name || name.trim() === '') { //debug trim() remove os espaços em branco do incio e fim da string
            response.status(400)
            response.json({err: "nome invalido."})
            return
        }

        if(user_id == undefined) {
            response.status(400)
            response.json({err: "usuário invalido."})
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

        var valid = await Habit.findNameByIdUser(name, user_id)
        if(valid) {
            response.status(406)
            response.json({err: "habito já existe."})
            return 
        }
        var done = await Habit.new(name, description, category_id, frequency, start_date, end_date, priority, reminders, user_id)
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
        const user_id = request.params.user_id
        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário invalido." });
        }
        
        const habits = await Habit.findNotArchived(user_id)

        if (habits && habits.length > 0) {
            response.status(200).json({ habits })
        } else {
            response.status(404).json({ err: "Nenhum hábito encontrado." })
        }
    }

    async getHabitsArchived(request, response) {
        const user_id = request.params.user_id

        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário invalido." });
        }
        const habits = await Habit.findArchived(user_id)

        if (habits && habits.length > 0) {
            response.status(200).json({ habits })
        } else {
            response.status(404).json({ err: "Nenhum hábito arquivado encontrado." })
        }
    }

    async getTopPriorities(request, response) {
        const user_id = request.params.user_id

        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário invalido." });
        }

        const habits = await Habit.findTopPriorities(user_id)

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

    async editHabit(request, response) {
        const id = request.params.id
        const {name, description, category_id, frequency, start_date, end_date, priority, reminders, user_id} = request.body
        if (!id || isNaN(id)) {
            return response.status(400).json({ err: "ID inválido" })
        }

        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "usuário invalido." })
        }

        var habit = await Habit.habitExist(id)
        if(!habit) {
            return response.status(404).json({ err: "habito não encontrada." })
        }
        var nameExists = await Habit.findNameByIdUser(name, user_id)
        if(nameExists && nameExists.id !== Number(id)) {
            return response.status(409).json({err: "nome de habito já existe."})
        }
        var result = await Habit.uptadeData(id, name, description, category_id, frequency, start_date, end_date, priority, reminders, user_id)
        if(result) {
            response.status(200)
            response.json({message: "Habito editado com sucesso."})
        }
        else {
            response.status(500)
            response.json({err: "Erro ao editar habito."})
        }
    }

    async finishedHabitCreate(request, response) {
        var {habit_id, difficulty, mood, reflection, location, hour} = request.body 
        habit_id = Number(habit_id)
        difficulty = Number(difficulty)
        mood = Number(mood)
        
        if (isNaN(habit_id)) {
            return response.status(400).json({ err: "Hábito invalido." })
        }

        if (isNaN(difficulty)) {
            return response.status(400).json({ err: "Nível de dificuldade invalida." })
        }

        if (isNaN(mood)) {
            return response.status(400).json({ err: "Humor invalido." })
        }

        if(hour == undefined) {
            return response.status(400).json({ err: "Tempo dedicado invalido." })
        }

        var valid = await Habit.finishHabitExist(habit_id)
        if(valid) {
            response.status(406)
            response.json({err: "Já existe uma finalização para esse habito."})
            return 
        }
        var done = await Habit.newFinishHabit(habit_id, difficulty, mood, reflection, location, hour)
        if(done) {
            var completed = await Habit.updateToCompleted(habit_id)
            if(!completed) {
                return response.status(500).json({err: "erro ao completar habito"})
            }

            // Buscar informações do hábito para criar a notificação
            var habit = await Habit.findById(habit_id)
            if(habit) {
                // Criar notificação
                const notificationData = {
                    type: 'habit_completed',
                    title: `Hábito "${habit.name}" Concluído`,
                    message: `Parabéns! Você concluiu o hábito "${habit.name}" com sucesso.`,
                    habitId: habit_id,
                    habitName: habit.name,
                    completedAt: new Date().toISOString(),
                    difficulty: difficulty,
                    mood: mood,
                    reflection: reflection,
                    location: location,
                    timeSpent: hour
                }
                
                await Notification.create(habit.user_id, notificationData)
            }

            response.status(200)
            response.send('Habito finalizado com sucesso.')
        }
        else {
            response.status(500)
            response.json({err: "erro ao completar habito."})
        }
    }


    async getHabitsCompletedToday(request, response) {
        const user_id = request.params.user_id;
        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário invalido." });
        }
        const count = await Habit.countCompletedToday(user_id);
        response.status(200).json({ count });
    }

    // Retorna o total de hábitos cadastrados por usuário
   // Retorna o total de hábitos cadastrados e concluídos (status 4) por usuário
    async getHabitsSummaryByUser(request, response) {
        const user_id = request.params.user_id;
        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }
        try {
            const total = await Habit.countAllHabitsByUser(user_id);
            const completed = await Habit.countCompletedHabitsByUser(user_id);
            response.status(200).json({ total, completed });
        } catch (err) {
            response.status(500).json({ err: "Erro ao buscar o resumo de hábitos do usuário." });
        }
    }

    // Retorna hábitos completados agrupados por mês
    async getCompletedHabitsByMonth(request, response) {
        const user_id = request.params.user_id;
        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }
        try {
            const completedHabits = await Habit.findCompletedHabitsByMonth(user_id);
            response.status(200).json({ completedHabits });
        } catch (err) {
            response.status(500).json({ err: "Erro ao buscar hábitos completados por mês." });
        }
    }

    async getHabitsActive(request, response) {
        const user_id = request.params.user_id;
        if (!user_id || isNaN(user_id)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }
        try {
            const count = await Habit.countActiveHabitsByUser(user_id);
            response.status(200).json({ active: count });
        } catch (err) {
            console.error("Erro ao buscar contagem de hábitos ativos:", err);
            response.status(500).json({ err: "Erro ao buscar o total de hábitos ativos." });
        }
    }

    async pizzaGraph(request, response) {
        const userId = request.params.user_id
        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }
        const result = await Habit.finishHabitGraph(userId);
        if (!result || result.length === 0) {
            return response.status(404).json({ err: "Nenhum dado para o gráfico encontrado para esse usuário." });
        } else {
            response.status(200).json({ result });
        }
    }

    async FrequencyGraph(request, response) {
        const userId = request.params.user_id
        if (!userId || isNaN(userId)) {
            return response.status(400).json({ err: "Usuário inválido." });
        }
        const result = await Habit.FrequencyHabitGraph(userId)
        if (!result || result.length === 0) {
            return response.status(404).json({ err: "Nenhum dado para o gráfico encontrado para esse usuário." });
        } else {
            response.status(200).json({ result });
        }
    }

}

module.exports = new HabitController()
