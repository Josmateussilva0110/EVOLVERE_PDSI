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
app.use('/uploads', express.static(path.join(__dirname, 'public', 'uploads')))
app.use(cors())



app.use("/",router)

app.listen(8080, '0.0.0.0', () => {
    console.log("Servidor rodando")
})
