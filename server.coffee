express          = require 'express'
app = global.app = express()

app.set 'port', process.env.PORT || 3777
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'

app.use express.static(__dirname + '/public')

logger = require('morgan')
app.use logger('dev')

methodOverride = require('method-override')
app.use methodOverride()

bodyParser = require('body-parser')
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })

multer  = require('multer')
app.use multer()

cookieParser = require('cookie-parser')
app.use cookieParser()

#session = require('express-session')
#app.use session
    #secret: process.env.SECRET || "YOURMOSTDARKSECRET",
    #resave: false,
    #saveUninitialized: false,
    #cookie: { maxAge: 60000 }

partials = require('express-partials')
app.use partials()

cookieSession = require('cookie-session')
app.use cookieSession
    keys: ['secret1', 'secret2']

validator = require 'express-validator'
app.use validator()


require './app/routes'
require './app/params'

#app.get '/', (req, res) ->
    #res.send "hello"

# change this to a better error handler in your code
# sending stacktrace to users in production is not good
#app.use (err, req, res, next) ->
#      res.send(err.stack)


app.listen app.get('port'), () ->
    console.log "Server started on port #{app.get('port')}."

