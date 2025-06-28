var bodyParser = require('body-parser')
var express = require("express")
var app = express()
var router = require("./routes/routes")
const fileUpload = require('express-fileupload')
const path = require('path')
const cors = require('cors')
const ReminderScheduler = require('./services/ReminderScheduler')

app.use(fileUpload())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(express.static(path.join(__dirname, 'public')));
app.use('/category_images', express.static(path.join(__dirname, 'public', 'category_images')))
app.use('/user_profile_images', express.static(path.join(__dirname, 'public', 'user_profile_images')))
app.use(cors())

app.use("/",router)

// Inicializar o scheduler de lembretes
function initializeReminderScheduler() {
    console.log('🕐 Inicializando scheduler de lembretes...');
    
    // Executar imediatamente na inicialização
    ReminderScheduler.processReminders();
    
    // Agendar execução a cada minuto
    setInterval(async () => {
        try {
            await ReminderScheduler.processReminders();
        } catch (error) {
            console.error('❌ Erro no scheduler automático:', error);
        }
    }, 60000); // 60 segundos = 1 minuto
    
    console.log('✅ Scheduler de lembretes inicializado - executando a cada minuto');
}

app.listen(8080, '0.0.0.0', () => {
    console.log("Servidor rodando")
    initializeReminderScheduler();
})
