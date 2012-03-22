{ _ } = require 'underscore'

mw = require './middleware'
{ renderTwoColumn, renderError, renderHistogram } = require './app'


app.get '/error', (req, res) ->
    renderError req, res, '404', 'la'

app.get '/histogram', mw.loadActiveBoulders, (req, res) ->
    renderHistogram req, res

app.get '/', mw.loadActiveBoulders, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'statistics'

app.get '/team', mw.loadActiveBoulders, mw.loadBoulders, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'team'


# ----------------------------------------------------------------------------
# Boulder search
# ----------------------------------------------------------------------------
#
app.get '/search', mw.loadActiveBoulders, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'search'

app.post '/search', mw.loadSearched, (req, res) ->


# ----------------------------------------------------------------------------
# Boulder presentation
# ----------------------------------------------------------------------------
#
app.get '/boulder/:boulder', mw.loadActiveBoulders, mw.loadSetters, mw.loadBoulder, mw.loadSettersOfBoulder, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'boulder'

app.get '/boulder/:boulder/vote/:stars', mw.loadBoulder, mw.vote, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/upgrade', mw.loadBoulder, mw.upgradeBoulder, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/downgrade', mw.loadBoulder, mw.downgradeBoulder, (req, res) ->
    res.redirect '/boulder/' + req.params['boulder']

app.post '/boulder/:boulder/remove', mw.loadBoulder, mw.removeBoulder, (req, res) ->
    res.redirect '/'

app.post '/boulder/:boulder/delete', mw.loadBoulder, mw.deleteBoulder, (req, res) ->
    res.redirect '/'


# ----------------------------------------------------------------------------
# Setter profile
# ----------------------------------------------------------------------------
#
app.get '/profile', mw.loadActiveBoulders, mw.loadProfile, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'profile', 'addboulder'

app.post '/add/boulder', mw.loadActiveBoulders, mw.loadProfile, mw.loadSetters, mw.createBoulder, (req, res) ->
    #renderTwoColumn req, res, 'profile', 'boulder'

app.get '/change/pw', mw.loadActiveBoulders, mw.loadProfile, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'profile', 'pwchange'

app.post '/change/pw', mw.changePW, (req, res) ->

app.get '/change/secret', mw.loadActiveBoulders, mw.loadProfile, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'profile', 'secretchange'

app.post '/change/secret', mw.changeSecret, (req, res) ->


# ----------------------------------------------------------------------------
# Setter presentation
# ----------------------------------------------------------------------------
#
app.get '/setter/:nickname', mw.loadActiveBoulders, mw.loadInactiveBoulders, mw.loadSetter, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'setter'

app.get '/add/setter', mw.loadActiveBoulders, mw.loadBoulder, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'boulder'

app.post '/add/setter', mw.createSetter, mw.loadProfile, (req, res) ->
    renderTwoColumn req, res, 'profile', 'boulder'


# ----------------------------------------------------------------------------
# Authentication
# ----------------------------------------------------------------------------
#
app.get '/login', mw.loadActiveBoulders, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'login'

app.post '/login', mw.auth, mw.loadActiveBoulders, mw.loadSetters, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'login'

app.get '/logout', mw.logout, (req, res) ->
    res.redirect '/'

# ----------------------------------------------------------------------------
# Routes for statistics
# ----------------------------------------------------------------------------
#
app.get '/stats/grade/:grade', mw.loadActiveBoulders, mw.loadSetters, mw.loadActiveGradeBoulders, (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'gradeboulderlist'


# ----------------------------------------------------------------------------
# Routes for activity (see github/wow...)
# ----------------------------------------------------------------------------
#
app.get 'activity', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'activity'

app.get 'activity/:setter_nickname', (req, res) ->
    renderTwoColumn req, res, 'boulderlist', 'activity'


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

