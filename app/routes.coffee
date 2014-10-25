{ _ } = require 'underscore'

mw = require './middleware'
{ renderTwoColumn, renderError, renderHistogram } = require './app'

# in most cases we need all active boulders and setters anyway
app.all '*', mw.loadActiveBoulders, mw.loadSetters, (req, res, next) ->
    next()


app.get '/error', (req, res) ->
    renderError req, res, '404', 'la'

app.get '/histogram', (req, res) ->
    renderHistogram req, res

app.get '/', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'statistics'

app.get '/team', mw.loadBoulders, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'team'

app.get '/balance', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'balance'

# ----------------------------------------------------------------------------
# Boulder search
# ----------------------------------------------------------------------------
#
app.get '/search', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'search'

app.post '/search', mw.loadSearched, (req, res) ->


# ----------------------------------------------------------------------------
# Boulder presentation
# ----------------------------------------------------------------------------
#
app.get '/boulder/:boulder', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'boulder'

app.post '/boulder/:boulder/like', mw.like, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/dislike', mw.dislike, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/vote-grade', mw.vote_grade, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/upgrade', mw.upgradeBoulder, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/downgrade', mw.downgradeBoulder, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/remove', mw.removeBoulder, (req, res) ->
    res.redirect '/'

app.post '/boulder/:boulder/delete', mw.deleteBoulder, (req, res) ->
    res.redirect '/'


# ----------------------------------------------------------------------------
# Setter profile
# ----------------------------------------------------------------------------
#
app.get '/profile', mw.loadProfile, (req, res) ->
    renderTwoColumn req, res, 'profile', 'addboulder'

app.post '/add/boulder', mw.loadProfile, mw.createBoulder, (req, res) ->
    #renderTwoColumn req, res, 'profile', 'boulder'

app.get '/batchremove', mw.loadProfile, (req, res) ->
    renderTwoColumn req, res, 'profile', 'batchremove'

app.post '/rem/batch', mw.loadProfile, mw.batchRemove, (req, res) ->
    #renderTwoColumn req, res, 'profile', 'boulder'

app.get '/change/pw', mw.loadProfile, (req, res) ->
    renderTwoColumn req, res, 'profile', 'pwchange'

app.post '/change/pw', mw.changePW, (req, res) ->

app.get '/change/secret', mw.loadProfile, (req, res) ->
    renderTwoColumn req, res, 'profile', 'secretchange'

app.post '/change/secret', mw.changeSecret, (req, res) ->


# ----------------------------------------------------------------------------
# Setter presentation
# ----------------------------------------------------------------------------
#
app.get '/setter/:nickname', mw.loadInactiveBoulders, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'setter'


#FIXME:
#app.get '/add/setter', (req, res) ->
#    renderTwoColumn req, res, 'boulderlist', 'boulder'

#app.post '/add/setter', mw.createSetter, mw.loadProfile, (req, res) ->
#    renderTwoColumn req, res, 'profile', 'boulder'


# ----------------------------------------------------------------------------
# Authentication
# ----------------------------------------------------------------------------
#
app.get '/login', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'login'

app.post '/login', mw.auth, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'login'

app.get '/logout', mw.logout, (req, res) ->
    res.redirect '/'

# ----------------------------------------------------------------------------
# Routes for statistics
# ----------------------------------------------------------------------------
#
app.get '/stats/grade/:grade', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'gradeboulderlist'

app.get '/stats/sector/:sector', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'sectorboulderlist'

# ----------------------------------------------------------------------------
# Routes for activity (see github/wow...)
# ----------------------------------------------------------------------------
#
#TODO:
#app.get 'activity', (req, res) ->
#    renderTwoColumn req, res, 'boulderlist', 'activity'

#app.get 'activity/:setter_nickname', (req, res) ->
#    renderTwoColumn req, res, 'boulderlist', 'activity'


#XXX: additional helper routes
#app.get 'find/sector/:sector_nr'
#app.get 'find/setter/:setter_nick'
#app.get 'find/boulder/:boulder_grade'


# ----------------------------------------------------------------------------
# Catch-all-route
# ----------------------------------------------------------------------------
#
app.get '*', (req, res) ->
    renderError req, res, 404, 'Seite nicht gefunden!'

