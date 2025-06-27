const Habit = require("../models/Habit");
const Notification = require("../models/Notification");

class ReminderScheduler {
    
    // Verifica e processa lembretes pendentes
    async processReminders() {
        try {
            console.log('🕐 Verificando lembretes...');
            
            // Buscar todos os hábitos ativos com lembretes
            const habits = await this.getActiveHabitsWithReminders();
            
            if (!habits || habits.length === 0) {
                console.log('📭 Nenhum hábito com lembretes encontrado');
                return;
            }
            
            console.log(`📋 Encontrados ${habits.length} hábitos com lembretes:`);
            
            // Mostrar detalhes dos hábitos encontrados
            habits.forEach((habit, index) => {
                console.log(`   ${index + 1}. Hábito ID: ${habit.id} - "${habit.name}"`);
                console.log(`      Lembretes: ${JSON.stringify(habit.reminders)}`);
                console.log(`      Usuário: ${habit.user_id}`);
                console.log('');
            });
            
            const now = new Date();
            let notificationsCreated = 0;
            
            for (const habit of habits) {
                const created = await this.processHabitReminders(habit, now);
                if (created) notificationsCreated++;
            }
            
            if (notificationsCreated > 0) {
                console.log(`✅ ${notificationsCreated} notificações de lembretes criadas.`);
            } else {
                console.log('⏰ Nenhum lembrete para executar no momento.');
            }
            
        } catch (error) {
            console.error('❌ Erro ao processar lembretes:', error);
        }
    }
    
    // Busca hábitos ativos que possuem lembretes
    async getActiveHabitsWithReminders() {
        try {
            const habits = await Habit.findAllActiveWithReminders();
            
            if (!habits) return [];
            
            // Filtrar apenas hábitos com lembretes válidos
            return habits.filter(habit => {
                if (!habit.reminders || !Array.isArray(habit.reminders)) {
                    return false;
                }
                
                // Verificar se há pelo menos um lembrete válido
                return habit.reminders.some(reminder => {
                    try {
                        const reminderDate = new Date(reminder);
                        return !isNaN(reminderDate.getTime());
                    } catch (e) {
                        return false;
                    }
                });
            });
            
        } catch (error) {
            console.error('Erro ao buscar hábitos com lembretes:', error);
            return [];
        }
    }
    
    // Processa lembretes de um hábito específico
    async processHabitReminders(habit, currentTime) {
        try {
            if (!habit.reminders || !Array.isArray(habit.reminders)) {
                return false;
            }
            
            console.log(`🔍 Processando lembretes do hábito ID: ${habit.id} - "${habit.name}"`);
            
            for (const reminderString of habit.reminders) {
                try {
                    const reminderDate = new Date(reminderString);
                    
                    if (isNaN(reminderDate.getTime())) {
                        console.log(`   ⚠️ Lembrete inválido: ${reminderString}`);
                        continue;
                    }
                    
                    console.log(`   📅 Lembrete: ${reminderDate.toLocaleString()}`);
                    
                    // Verificar se o lembrete deve ser executado agora (com tolerância de 1 minuto)
                    const timeDiff = Math.abs(currentTime.getTime() - reminderDate.getTime());
                    const oneMinute = 60 * 1000; // 1 minuto em milissegundos
                    
                    if (timeDiff <= oneMinute && reminderDate <= currentTime) {
                        console.log(`   ⏰ Lembrete deve ser executado agora!`);
                        
                        // Verificar se já existe uma notificação para este lembrete hoje
                        const notificationExists = await this.checkNotificationExists(habit.id, reminderDate);
                        
                        if (!notificationExists) {
                            await this.createReminderNotification(habit, reminderDate);
                            console.log(`   🔔 Notificação criada para hábito "${habit.name}" - ${reminderDate.toLocaleString()}`);
                            return true;
                        } else {
                            console.log(`   📝 Notificação já existe para hoje`);
                        }
                    } else {
                        console.log(`   ⏳ Lembrete ainda não é hora (diferença: ${Math.round(timeDiff / 1000)}s)`);
                    }
                    
                } catch (error) {
                    console.error(`   ❌ Erro ao processar lembrete ${reminderString}:`, error);
                }
            }
            
        } catch (error) {
            console.error(`❌ Erro ao processar lembretes do hábito ${habit.id}:`, error);
        }
        
        return false;
    }
    
    // Verifica se já existe uma notificação para este lembrete hoje
    async checkNotificationExists(habitId, reminderDate) {
        try {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            
            // Buscar notificações do hábito criadas hoje
            const notifications = await Notification.findByHabitIdAndDateRange(
                habitId, 
                today.toISOString(), 
                tomorrow.toISOString()
            );
            
            return notifications && notifications.length > 0;
            
        } catch (error) {
            console.error('Erro ao verificar notificação existente:', error);
            return false;
        }
    }
    
    // Cria uma notificação de lembrete
    async createReminderNotification(habit, reminderDate) {
        try {
            const notificationData = {
                type: 'habit_reminder',
                title: `Lembrete: ${habit.name}`,
                message: `É hora de realizar seu hábito "${habit.name}". Não esqueça de manter sua rotina!`,
                habitId: habit.id,
                habitName: habit.name,
                reminderTime: reminderDate.toISOString(),
                createdAt: new Date().toISOString()
            };
            
            const success = await Notification.create(habit.user_id, notificationData);
            
            if (!success) {
                console.error(`❌ Falha ao criar notificação para hábito ${habit.id}`);
            }
            
            return success;
            
        } catch (error) {
            console.error(`Erro ao criar notificação de lembrete para hábito ${habit.id}:`, error);
            return false;
        }
    }
}

module.exports = new ReminderScheduler(); 