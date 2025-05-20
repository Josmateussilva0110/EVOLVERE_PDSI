const Category = require("../models/Category")
const path = require('path')

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

        let iconPath = null;

        if (request.files && request.files.icon) {
            const imageFile = request.files.icon;
    
            if (imageFile.size > 5 * 1024 * 1024) {
                return response.status(400).json({ err: "A imagem deve ter no máximo 5MB!" });
            }
    
            const fileName = Date.now() + path.extname(imageFile.name);
            const uploadPath = path.join(__dirname, "..", "public", "uploads", fileName);
    
            try {
                await imageFile.mv(uploadPath);
                iconPath = "/uploads/" + fileName; 
            } catch (err) {
                console.error("Erro ao salvar a imagem:", err);
                return response.status(500).json({ err: "Erro ao salvar a imagem." });
            }
        }

        await Category.new(name, description, color, iconPath)
        response.status(200)
        response.send('Cadastro realizado com sucesso.')
    }
  
    async getCategories(request, response) {
        try {
            const categories = await Category.findAll();
            if (categories.length > 0) {
                response.status(200).json({ categories: categories });
            } else {
                response.status(404).json({ 
                    err: "Nenhuma categoria ativa encontrada.",
                    categories: [] 
                });
            }
        } catch (err) {
            response.status(500).json({ 
                err: "Erro interno ao buscar categorias ativas",
                categories: [] 
            });
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

    async delete(request, response) {
        try {
            const id = request.params.id;
            
            if (!id || isNaN(id)) {
                return response.status(400).json({ err: "ID inválido" });
            }

            const category = await Category.findById(id);
            if (!category) {
                return response.status(404).json({ err: "Categoria não encontrada" });
            }

            await Category.delete(id);
            response.status(200).json({ message: "Categoria excluída com sucesso" });
        } catch (error) {
            console.error("Erro ao excluir categoria:", error);
            response.status(500).json({ err: "Erro interno ao excluir categoria" });
        }
    }

    async archiveCategory(request, response) {
        try {
            const id = request.params.id;
            
            if (!id || isNaN(id)) {
                return response.status(400).json({ err: "ID inválido" });
            }

            const category = await Category.findById(id);
            if (!category) {
                return response.status(404).json({ err: "Categoria não encontrada" });
            }

            const success = await Category.archive(id);
            if (success) {
                response.status(200).json({ message: "Categoria arquivada com sucesso" });
            } else {
                response.status(500).json({ err: "Erro ao arquivar categoria" });
            }
        } catch (error) {
            console.error("Erro ao arquivar categoria:", error);
            response.status(500).json({ err: "Erro interno ao arquivar categoria" });
        }
    }

    async getArchivedCategories(request, response) {
        try {
            const categories = await Category.findArchived();
            response.status(200).json({ categories: categories });
        } catch (err) {
            response.status(500).json({ 
                err: "Erro interno ao buscar categorias arquivadas",
                categories: [] 
            });
        }
    }

    async unarchiveCategory(request, response) {
        try {
            const id = request.params.id;
            if (!id || isNaN(id)) {
                return response.status(400).json({ err: "ID inválido" });
            }
            const category = await Category.findById(id);
            if (!category) {
                return response.status(404).json({ err: "Categoria não encontrada" });
            }
            const success = await Category.unarchive(id);
            if (success) {
                response.status(200).json({ message: "Categoria restaurada com sucesso" });
            } else {
                response.status(500).json({ err: "Erro ao restaurar categoria" });
            }
        } catch (error) {
            console.error("Erro ao restaurar categoria:", error);
            response.status(500).json({ err: "Erro interno ao restaurar categoria" });
        }
    }
}

module.exports = new CategoryController()
