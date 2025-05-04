class HomeController{

    async index(request, response){
        res.send("APP");
    }

}

module.exports = new HomeController();
