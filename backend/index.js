var bodyParser = require('body-parser')
var express = require("express")
var app = express()
var router = require("./routes/routes")
const fileUpload = require('express-fileupload')
const path = require('path')
const cors = require('cors') 


app.use(fileUpload())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(express.static(path.join(__dirname, 'public')));
app.use('/category_images', express.static(path.join(__dirname, 'public', 'category_images')))
app.use('/user_profile_images', express.static(path.join(__dirname, 'public', 'user_profile_images')))
app.use(cors())



app.use("/",router)

app.listen(8080, '0.0.0.0', () => {
    console.log("Servidor rodando")
})
