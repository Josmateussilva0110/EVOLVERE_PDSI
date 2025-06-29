var knex = require("../database/connection")
const formatDateForMySQL = require("../utils/format_date")

class Habit {

    async findName(name) {
        try {
            var result = await knex.select("*").from("habits").where({name: name})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar nome do habito: ', err)
            return false
        }
    }


    async findNameByIdUser(name, user_id) {
        try {
            var result = await knex.select("*").from("habits").where({name: name}).andWhere('user_id', user_id)
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar nome do habito: ', err)
            return false
        }
    }




    async habitExist(id) {
        try {
            var result = await knex.select(["id"]).from("habits").where({id: id})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar id do habito: ', err)
            return false
        }
    }

    async finishHabitExist(id) {
        try {
            var result = await knex.select(["habit_id"]).from("finish_habit").where({habit_id: id})
            if(result.length > 0) {
                return true
            }
            else {
                return false
            }
        } catch(err) {
            console.log('erro em buscar id do habito: ', err)
            return false
        }
    }

    async new(name, description, category_id, frequency, start_date, end_date, priority, reminders, user_id) {
        try {
            await knex.insert({name, description, category_id, frequency, start_date, end_date, priority, reminders: reminders ? JSON.stringify(reminders) : null, user_id}).table("habits")
            return true
        } catch(err) {
            console.log('erro em cadastrar habito: ', err)
            return false
        }
    }

    async newFinishHabit(habit_id, difficulty, mood, reflection, location, hour) {
        try {
            await knex.insert({habit_id, difficulty, mood, reflection, location, hour}).table("finish_habit")
            return true
        } catch(err) {
            console.log('erro em cadastrar a finalização do habito: ', err)
            return false
        }
    }



    async findAll() {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .select(
                'h.id',
                'h.name',
                'h.description',
                'c.name as categoria',
                'h.frequency',
                'h.start_date',
                'h.end_date',
                'h.priority',
                'h.reminders',
                'h.status',
            );

            const habits = result.map(habit => ({
            ...habit,
            reminders: Array.isArray(habit.reminders) ? habit.reminders : [],
            }));

            if(habits)
                return habits;
            else 
                return undefined;
        } catch (err) {
            console.error('Erro em findAll hábitos:', err);
            return undefined;
        }
    }
    async findNotArchived(user_id) {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .where('h.status', '=', 1).andWhere('h.user_id', user_id)
            .select(
                'h.id',
                'h.name',
                'h.description',
                'c.name as categoria',
                'h.frequency',
                'h.start_date',
                'h.end_date',
                'h.priority',
                'h.reminders',
                'h.status',
                'h.user_id'
            );

            const habits = result.map(habit => ({
            ...habit,
            reminders: Array.isArray(habit.reminders) ? habit.reminders : [],
            }));

            if(habits)
                return habits;
            else 
                return undefined;
        } catch (err) {
            console.error('Erro em findAll hábitos:', err);
            return undefined;
        }
    }

    async findArchived(user_id) {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .where('h.status', '=', 3).andWhere('h.user_id', user_id)
            .select(
                'h.id',
                'h.name',
                'h.description',
                'c.name as categoria',
                'h.frequency',
                'h.start_date',
                'h.end_date',
                'h.priority',
                'h.reminders',
                'h.status',
            );

            const habits = result.map(habit => ({
            ...habit,
            reminders: Array.isArray(habit.reminders) ? habit.reminders : [],
            }));

            if(habits)
                return habits;
            else 
                return undefined;
        } catch (err) {
            console.error('Erro em findAll hábitos:', err);
            return undefined;
        }
    }

    async findById(id) {
        try {
            var result = await knex.select(["id", "name", "description", "category_id", "frequency", "start_date", "end_date", "priority", "reminders", "status", "user_id"]).where({id: id}).table("habits")
            if(result.length > 0) 
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById', err)
            return undefined
        }
    }
    
    async findByName(name) {
        try {
            var result = await knex.select(["id", "name", "description", "category_id", "frequency", "start_date", "end_date", "priority", "reminders", "status", "user_id"]).where({name: name}).table("habits")
            if(result.length > 0) 
                return result[0]
            else 
                return undefined
        } catch(err) {
            console.log('erro no findById', err)
            return undefined
        }
    }
    async delete(id) {
        try {
            await knex("habits").where({id: id}).del()
            return true
        } catch(err) {
            console.log('erro ao deletar habito: ', err)
            return false
        }
    }

    async archive(id) {
        try {
            await knex("habits").where({id: id}).update({status: 3})
            return true
        } catch(err) {
            console.log('erro ao arquivar habito: ', err)
            return false
        }
    }

    async updateToActive(id) {
        try {
            await knex("habits").where({id: id}).update({status: 1})
            return true
        } catch(err) {
            console.log('erro ao arquivar habito: ', err)
            return false
        }
    }

    async updateToCompleted(id) {
        try {
            await knex("habits").where({id: id}).update({status: 4})
            return true
        } catch(err) {
            console.log('erro ao arquivar habito: ', err)
            return false
        }
    }


    async uptadeData(id, name, description, category_id, frequency, start_date, end_date, priority, reminders, user_id) {
        try {
            const updates = {
                name,
                description,
                category_id,
                frequency: frequency ? JSON.stringify(frequency) : undefined,
                start_date: start_date ? formatDateForMySQL(start_date) : undefined,
                end_date: end_date ? formatDateForMySQL(end_date) : undefined,
                priority,
                reminders: reminders ? JSON.stringify(reminders) : undefined,
                user_id,
                updated_at: knex.fn.now()
            }

            // Remove valor undefined ou null
            Object.keys(updates).forEach(key => {
                if (updates[key] === undefined) {
                    delete updates[key]
                }
            })
            
            await knex.table("habits").where({ id }).update(updates)
            return true
        } catch (err) {
            console.log('erro em editar habito: ', err)
            return false
        }
    }

    async findTopPriorities(user_id) {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .where('h.status', '=', 1).andWhere('h.user_id', user_id)
            .andWhere('h.user_id', user_id)
            .orderBy('h.priority', 'asc')
            .limit(3)
            .select(
                'h.id',
                'h.name',
                'h.description',
                'c.name as categoria',
                'h.frequency',
                'h.start_date',
                'h.end_date',
                'h.priority',
                'h.reminders',
                'h.status',
            );

            const habits = result.map(habit => ({
                ...habit,
                reminders: Array.isArray(habit.reminders) ? habit.reminders : [],
            }));

            if(habits)
                return habits;
            else 
                return undefined;
        } catch (err) {
            console.error('Erro em buscar hábitos prioritários:', err);
            return undefined;
        }
    }

    // Busca a contagem de hábitos concluídos hoje por usuário
    async countCompletedToday(user_id) {
        try {
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const dd = String(today.getDate()).padStart(2, '0');
            const todayStr = `${yyyy}-${mm}-${dd}`;

            const result = await knex('habits as h')
                .where('h.status', '=', 4)
                .andWhere('h.user_id', user_id)
                .andWhereRaw('DATE(h.updated_at) = ?', [todayStr])
                .count('h.id as count');

            return result[0].count || 0;
        } catch (err) {
            console.error('Erro em contar hábitos concluídos hoje:', err);
            return 0;
        }
    }

    // Função para contar o total de hábitos cadastrados por usuário
    async countAllHabitsByUser(user_id) {
        try {
            const result = await knex('habits').where({ user_id }).count('id as total');
            return result[0].total || 0;
        } catch (err) {
            console.error('Erro ao contar o total de hábitos por usuário:', err);
            return 0;
        }
    }

    // Função para contar o total de hábitos concluídos (status 4) por usuário
    async countCompletedHabitsByUser(user_id) {
        try {
            const result = await knex('habits').where({ user_id, status: 4 }).count('id as total');
            return result[0].total || 0;
        } catch (err) {
            console.error('Erro ao contar hábitos concluídos por usuário:', err);
            return 0;
        }
    }

    // Função para contar o total de hábitos ativos (status 1) por usuário
    async countActiveHabitsByUser(user_id) {
        try {
            const result = await knex('habits').where({ user_id, status: 1 }).count('id as total');
            return result[0].total || 0;
        } catch (err) {
            console.error('Erro ao contar hábitos ativos por usuário:', err);
            return 0;
        }
    }

    // Função para buscar hábitos completados agrupados por mês
    async findCompletedHabitsByMonth(user_id) {
        try {
            const result = await knex('habits as h')
                .leftJoin('category as c', 'h.category_id', 'c.id')
                .where('h.status', '=', 4)
                .andWhere('h.user_id', user_id)
                .select(
                    'h.id',
                    'h.name',
                    'h.description',
                    'c.name as categoria',
                    // Converte a data de UTC para o fuso de Brasília (-03:00)
                    knex.raw("CONVERT_TZ(h.updated_at, '+00:00', '-03:00') as updated_at"),
                    knex.raw("DATE_FORMAT(CONVERT_TZ(h.updated_at, '+00:00', '-03:00'), '%Y-%m') as month_year")
                )
                .orderBy('h.updated_at', 'desc');

            // Agrupar por mês
            const groupedByMonth = {};
            result.forEach(habit => {
                const monthYear = habit.month_year;
                if (!groupedByMonth[monthYear]) {
                    groupedByMonth[monthYear] = [];
                }
                groupedByMonth[monthYear].push({
                    id: habit.id,
                    name: habit.name,
                    description: habit.description,
                    categoria: habit.categoria,
                    completedAt: habit.updated_at
                });
            });

            return groupedByMonth;
        } catch (err) {
            console.error('Erro ao buscar hábitos completados por mês:', err);
            return {};
        }
    }

    async finishHabitGraph(userId) {
        try {
            const result = await knex.raw(`
                SELECT 
                    CASE fh.mood
                        WHEN 0 THEN 'Neutro'
                        WHEN 1 THEN 'Feliz'
                        WHEN 2 THEN 'Triste'
                        ELSE 'Desconhecido'
                    END AS label,
                    COUNT(*) as value
                FROM finish_habit fh
                JOIN habits h ON fh.habit_id = h.id
                WHERE h.user_id = ?
                GROUP BY fh.mood;
            `, [userId]);

            if (result[0].length > 0) {
                return result[0];
            } else {
                return [];
            }
        } catch (err) {
            console.error('Erro ao buscar dados de gráfico em finalizar:', err);
            return [];
        }
    }

    async FrequencyHabitGraph(userId) {
        try {
            const result = await knex.raw(`
                SELECT 
                    JSON_UNQUOTE(JSON_EXTRACT(frequency, '$.option')) AS \`option\`,
                    COUNT(*) as value
                FROM habits
                WHERE user_id = ?
                GROUP BY JSON_UNQUOTE(JSON_EXTRACT(frequency, '$.option'));
            `, [userId])
            if(result[0].length > 0) {
                return result[0]
            }
            else {
                return []
            }
        } catch(err) {
            console.error('Erro ao buscar dados de gráfico em habitos:', err);
            return [];
        }
    }
    async findAllActiveWithReminders() {
        try {
            const result = await knex('habits as h')
            .leftJoin('category as c', 'h.category_id', 'c.id')
            .where('h.status', '=', 1)
            .select(
                'h.id',
                'h.name',
                'h.description',
                'c.name as categoria',
                'h.frequency',
                'h.start_date',
                'h.end_date',
                'h.priority',
                'h.reminders',
                'h.status',
                'h.user_id'
            );

            const habits = result.map(habit => ({
            ...habit,
            reminders: Array.isArray(habit.reminders) ? habit.reminders : [],
            }));

            if(habits)
                return habits;
            else 
                return undefined;
        } catch (err) {
            console.error('Erro em findAllActiveWithReminders:', err);
            return undefined;
        }
    }

}

module.exports = new Habit()
