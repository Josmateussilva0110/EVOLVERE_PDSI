const ReminderScheduler = require("../services/ReminderScheduler");

class ReminderController {

    // Endpoint para processar lembretes manualmente
    async processReminders(request, response) {
        try {
            console.log('🔄 Processando lembretes...');
            
            await ReminderScheduler.processReminders();
            
            response.status(200).json({
                message: 'Lembretes processados com sucesso',
                timestamp: new Date().toISOString()
            });
            
        } catch (error) {
            console.error('❌ Erro no processamento de lembretes:', error);
            response.status(500).json({
                error: 'Erro interno do servidor ao processar lembretes',
                details: error.message
            });
        }
    }
}

module.exports = new ReminderController(); 