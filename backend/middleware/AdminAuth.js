var jwt = require("jsonwebtoken")
var secret = "fjskhfrjkgjrhdkfjklnlashdjhjdfsbdfnbmsfbrfndbndbsmoiwwq"

module.exports = function(request, response, next) {
    const authToken = request.headers['authorization']

    if(authToken != undefined) {
        const bearer = authToken.split(' ')
        var token = bearer[1]

        try {
            var decoded = jwt.verify(token, secret)
            if(decoded.role == 1) { //admin 1 normal 0
                next()
            }
            else {
                response.status(403)
                response.send('Não autorizado.')
                return
            }
            
        } catch(err) {
            response.status(403)
            response.send('Não autorizado.')
            return
        }
        

    }
    else {
        response.status(403)
        response.send('Não autorizado.')
        return
    }
}