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
  
    async getCategories(request, response) {
        var categories = await Category.findAll()
        if(categories.length > 0) {
            response.status(200)
            response.json({categories})
        }
        else {
            response.status(404)
            response.json({err: 'Nenhuma categoria cadastrada.'})
        }
    }

    async findCategory(request, response) {
        var id = request.params.id
        if(!isNaN(id)) {
            var category = await Category.findById(id)
            if(category != undefined) {
                response.status(200)
                response.json({category})
            }
            else {
                response.status(404)
                response.json({err: 'Categoria não encontrada.'})
            }
        }
        else 
        {
            response.status(400)
            response.json({err: 'Id invalido.'})
        }
    }
}

module.exports = new CategoryController()
