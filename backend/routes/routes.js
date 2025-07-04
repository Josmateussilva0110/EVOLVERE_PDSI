var express = require("express")
var router = express.Router()
const HomeController = require("../controllers/HomeController")
const UserController = require("../controllers/UserController")
const CategoryController = require("../controllers/categoryController")
const HabitController = require("../controllers/habitController")
const ProgressController = require("../controllers/ProgressController")
const NotificationController = require("../controllers/NotificationController")
const ReminderController = require("../controllers/ReminderController")


// rotas para o usuário
router.get('/', HomeController.index)
router.post('/user', UserController.create)
router.get("/users", UserController.index)
router.get("/user/:id", UserController.findUser)
router.get("/user/email/:email", UserController.findEmailUser)
router.delete("/user/:id", UserController.remove)
router.post("/recoverpassword", UserController.recoverPassword)
router.post("/changepassword", UserController.changePassword)
router.post("/login", UserController.login)
router.put("/user/edit/:id", UserController.editProfile)
router.put("/user/edit_name/:id", UserController.editUsername)
router.put("/user/edit_email/:id", UserController.editEmail)
router.post("/user/upload_image/:id", UserController.uploadProfileImage)
router.get("/user/profile/:id", UserController.getLoggedUserInfo)
router.post("/send_email", UserController.send_token)
router.post("/verify_code", UserController.verify_code)
router.post("/reset_password", UserController.reset_password)

// -------------------------------------------------------------------------

// rotas para categoria
router.post("/category", CategoryController.create)
router.get("/categories/:id", CategoryController.getCategories)
router.get("/category/:id", CategoryController.findCategory)
router.delete("/category/:id", CategoryController.delete)
router.patch("/category/:id/archive", CategoryController.archiveCategory)
router.get("/categories/not_archived/:id", CategoryController.getNotArchivedCategories)
router.get("/categories/archived/:id", CategoryController.getArchivedCategories)
router.patch("/category/:id/unarchive", CategoryController.unarchiveCategory)
router.patch("/category/:id", CategoryController.updateCategory)
router.get("/category/get_id/:name", CategoryController.getIdByName)

// -------------------------------------------------------------------------

// rotas para hábitos
router.post('/habit', HabitController.create)
router.get("/habits", HabitController.getAllHabits)
router.get("/habits/not_archived/:user_id", HabitController.getHabitsNotArchived)
router.get("/habits/archived/:user_id", HabitController.getHabitsArchived)
router.get("/habits/top_priorities/:user_id", HabitController.getTopPriorities)
router.delete("/habit/:id", HabitController.remove)
router.post("/habit/archive/:id", HabitController.archiveHabit)
router.post("/habit/active/:id", HabitController.setHabitToActive)
router.patch("/habit/:id", HabitController.editHabit)
router.post("/finished_habit", HabitController.finishedHabitCreate)
router.get("/habits/completed_today/:user_id", HabitController.getHabitsCompletedToday)
router.get("/habits/total/:user_id", HabitController.getHabitsSummaryByUser)
router.get("/habits/completed_by_month/:user_id", HabitController.getCompletedHabitsByMonth)
router.get("/habits/active/:user_id", HabitController.getHabitsActive)
router.get("/habit/graph/pizza/:user_id", HabitController.pizzaGraph)
router.get("/habit/graph/Frequency/:user_id", HabitController.FrequencyGraph)

// -------------------------------------------------------------------------

//rotas para progresso
router.post("/habit_progress", ProgressController.habitProgressCreate)
router.get("/habits/progress/all/:habit_id", ProgressController.getHabitsProgress)
router.delete("/habit/progress/:id", ProgressController.removeProgress)
router.post("/habit/progress/complete/:id", ProgressController.completeProgress)
router.post("/habit/progress/cancel/:id", ProgressController.cancelProgress)
router.patch("/habit/progress/edit/:id", ProgressController.editProgress)
router.get("/habit/graph/bar/:user_id", ProgressController.barGraph)

// -------------------------------------------------------------------------

//rotas para notificações
router.post("/notification", NotificationController.create)
router.get("/notifications", NotificationController.index)
router.get("/notification/:id", NotificationController.findById)
router.get("/notifications/user/:userId", NotificationController.findByUserId)
router.delete("/notification/:id", NotificationController.remove)
router.delete("/notifications/user/:userId", NotificationController.removeByUserId)
router.patch("/notification/:id/status", NotificationController.updateStatus)
router.get("/notifications/read/count/:userId", NotificationController.countReadByUserId)
router.get("/notifications/unread/count/:userId", NotificationController.countUnreadByUserId)

// -------------------------------------------------------------------------

//rota para processar lembretes
router.post("/reminders/process", ReminderController.processReminders)

module.exports = router
