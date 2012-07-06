
express   = require 'express'
validator = require 'express-validator'
#up        = require 'up'

app = global.app = express.createServer()

app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'

app.use express.static(__dirname + '/public')
app.use express.bodyParser()
app.use express.logger()
app.use express.cookieParser()
app.use express.methodOverride()
app.use validator

app.use express.session
    secret: process.env.SECRET || "YOURMOSTDARKSECRET"

require './app/routes'
require './app/params'
app.listen 3000

#master = app.listen 3000
#srv = up master, __dirname + '/'

#process.on 'SIGUSR2', () ->
    #srv.reload()
