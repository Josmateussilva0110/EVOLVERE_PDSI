const Category = require("../models/Category")

class CategoryController {

    async create(request, response) {
        var {name, description, color, icon} = request.body
        if(name == undefined) {
            response.status(400)
            response.json({err: "categoria invalida."})
            return
        }

        var valid = await Category.findCategoryName(name)
        if(valid) {
            response.status(406)
            response.json({err: "categoria já existe."})
            return 
        }

        await Category.new(name, description, color, icon)
        response.status(200)
        response.send('Cadastro realizado com sucesso.')
    }

}

module.exports = new CategoryController()
