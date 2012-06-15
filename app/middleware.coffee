
{ _ } = require 'underscore'
{ renderTwoColumn, renderError } = require './app'
{ fromGradeID } = require '../app/helpers'

db      = require('../database')
Setter  = db.model('setter')
Boulder = db.model('boulder')



isAdmin = (req) ->
    req.session.auth_setter_role is 'admin'

isAuth = (req) ->
    req.session.auth_setter_id?

isSecretValid = (req) ->
    req.body.secret is req.session?.auth_setter_secret


# ----------------------------------------------------------------------------
# Boulder loading
# ----------------------------------------------------------------------------
#
exports.loadBoulders = (req, res, next) ->
    req.bs = {}
    Boulder.find().sort('date', '-1').exec (err, boulders) ->
        return renderError req, res, 500, { err } if err
        req.all_boulders = boulders; next()

exports.loadActiveBoulders = (req, res, next) ->
    Boulder.find({ 'removed' : null }).sort('date', '-1', 'grade', '1', 'gradenr', '1').exec (err, boulders) ->
        return renderError req, res, 500, { err } if err
        req.boulders = boulders; next()

exports.loadInactiveBoulders = (req, res, next) ->
    Boulder.find({ 'removed' : {$ne: null} }).sort('date', '-1').exec (err, boulders) ->
        return renderError req, res, 500, { err } if err
        req.inactive_boulders = boulders; next()


# ----------------------------------------------------------------------------
# Show boulder search result
# ----------------------------------------------------------------------------
#
exports.loadSearched = (req, res, next) ->
    if req.body.grade?
        if req.body.gradenr is ""
            res.redirect "/stats/grade/#{fromGradeID req.body.grade}"
        else
            Boulder.findOne { 'grade' : req.body.grade, 'gradenr' : req.body.gradenr}, (err, boulder) ->
                if boulder?.id
                    res.redirect "/boulder/#{boulder.id}"
                else
                    res.redirect "/search"
    else
        res.redirect "/search"


# ----------------------------------------------------------------------------
# Actions on a boulder
# ----------------------------------------------------------------------------
#
exports.downgradeBoulder = (req, res, next) ->
    if req.body.gradenr isnt "" and isAuth(req) and isAdmin(req) and isSecretValid(req)
        Boulder.downgrade(req.params['boulder'], req.body.gradenr)
    next()


exports.upgradeBoulder = (req, res, next) ->
    if req.body.gradenr isnt "" and isAuth(req) and isAdmin(req) and isSecretValid(req)
        Boulder.upgrade(req.params['boulder'], req.body.gradenr)
    next()


exports.deleteBoulder = (req, res, next) ->
    if isAuth(req) and isAdmin(req) and isSecretValid(req)
        req.boulder.remove()
    next()


exports.removeBoulder = (req, res, next) ->
    if isAuth(req) and isSecretValid(req)
        Boulder.unscrew(req.params['boulder'])
    next()


exports.like = (req, res, next) ->
    now = new Date()
    if req.session.next_vote < now.getTime() or not req.session.next_vote?
        new_seconds = now.getSeconds() + 5
        now.setSeconds new_seconds
        req.session.next_vote = now.getTime()
        Boulder.like(req.params['boulder'])

    next()


exports.dislike = (req, res, next) ->
    now = new Date()
    if req.session.next_vote < now.getTime() or not req.session.next_vote?
        new_seconds = now.getSeconds() + 5
        now.setSeconds new_seconds
        req.session.next_vote = now.getTime()
        Boulder.dislike(req.params['boulder'])

    next()


# ----------------------------------------------------------------------------
# Actions on a setter
# ----------------------------------------------------------------------------
#
exports.changePW = (req, res, next) ->
    if isAuth(req) and req.body.newpw is req.body.newpw_check
        Setter.findOne { '_id': req.session.auth_setter_id }, (err, setter) ->
            if req.body.oldpw is setter.password
                setter.password = req.body.newpw
                setter.save()
                res.redirect '/profile'
            else
                res.redirect '/change/pw'
    else
        res.redirect '/change/pw'


exports.changeSecret = (req, res, next) ->
    if isAuth(req) and req.body.new_secret is req.body.new_secret_check
        Setter.findOne { '_id': req.session.auth_setter_id }, (err, setter) ->
            if req.body.old_secret is setter.secret
                setter.secret = req.body.new_secret
                setter.save()
                req.session.auth_setter_secret = req.body.new_secret
                res.redirect '/profile'
            else
                res.redirect '/change/secret'

    else
        res.redirect '/change/secret'


# ----------------------------------------------------------------------------
# Loading setters
# ----------------------------------------------------------------------------
#
exports.loadSetters = (req, res, next) ->
    Setter.find().sort('nickname', '1').exec (err, setters) ->
        return renderError req, res, 500, { err } if err
        req.setters = setters; next()


# ----------------------------------------------------------------------------
# Setter authentication
# ----------------------------------------------------------------------------
#
exports.auth = (req, res, next) ->
    if req.body.nickname isnt "" or req.body.password isnt ""
        Setter.auth req.body.nickname, req.body.password, (err, setter) ->
            if !err and setter?
                req.auth_setter = setter
                req.session.auth_setter_id = setter._id
                req.session.auth_setter_name = setter.name
                req.session.auth_setter_role = setter.role
                req.session.auth_setter_secret = setter.secret
                res.redirect "/profile"
            else
                next()
    else
        next()


exports.logout = (req, res, next) ->
    delete req.session.auth_setter_id
    delete req.session.auth_setter_name
    delete req.session.auth_setter_role
    delete req.session.auth_setter_secret
    next()


# ----------------------------------------------------------------------------
# Authenticated setter actions
# ----------------------------------------------------------------------------
#
exports.loadProfile = (req, res, next) ->
    if isAuth(req)
        Setter.findOne { '_id':  req.session.auth_setter_id}, (err, setter) ->
            return renderError req, res, 500, { err } if err
            req.setter = setter
            Boulder.find({ 'setters' : req.setter._id}).sort('date', '-1').exec (err, setter_boulders) ->
                return renderError req, res, 500, { err } if err
                req.setter_boulders = setter_boulders; next()
    else
        res.redirect "/login"


exports.createBoulder = (req, res, next) ->

    errors = []
    req.onValidationError (msg) ->
        errors.push msg

    req.assert('setter_nicks', 'Mindestens ein Schrauber auswaehlen!').notNull()
    req.assert('grade'       , 'Grade auswaehlen!').notNull()
    req.assert('sector'      , 'Sektor auswaehlen!').notNull()
    req.assert('gradenr'     , 'Grade nummer muss eine Zahl zwischen 1 und 50 sein!').isInt()
    req.assert('gradenr'     , 'Grade nummer muss kleiner als 50 sein!').max(50)
    req.assert('gradenr'     , 'Grade nummer muss groesser als 0 sein!').min(1)

    if not isSecretValid(req)
        errors.push 'Falsches secret eingegeben'

    if errors.length
        req.errors = errors
        renderTwoColumn req, res, 'profile', 'addboulder'
        return
    else
        setter_nicks = []
        if req.body.setter_nicks instanceof Array
            setter_nicks = req.body.setter_nicks
        else
            setter_nicks.push(req.body.setter_nicks)

        Setter.find { 'nickname': { $in : setter_nicks } }, (err, setters) ->
            setterIDs = []
            for setter in setters
                setterIDs.push setter._id

            data = { setters: setterIDs, grade: req.body.grade, gradenr: req.body.gradenr, sector: req.body.sector, name: req.body.name, comments: req.body.comments, addedBy: req.session.auth_setter_id}
            new Boulder(data).save (err, boulder) ->
                if err
                    console.log err
                    req.errors = [err]
                    renderTwoColumn req, res, 'profile', 'addboulder'
                    return
                else
                    res.redirect '/boulder/' + boulder.id


# ----------------------------------------------------------------------------
# TODO
# ----------------------------------------------------------------------------
#
exports.createSetter = (req, res, next) ->
    next()


