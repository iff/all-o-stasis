
{ _ } = require 'underscore'
{ renderTwoColumn, renderError } = require './app'

db      = require('../database')
Setter  = db.model('setter')
Boulder = db.model('boulder')


# ----------------------------------------------------------------------------
# Helper methods
# ----------------------------------------------------------------------------
#
gradeStringToID = (grade_str) ->
    if grade_str is "yellow"
        return 0
    else if grade_str is "green"
        return 1
    else if grade_str is "orange"
        return 2
    else if grade_str is "blue"
        return 3
    else if grade_str is "red"
        return 4
    else if grade_str is "white"
        return 5
    else
        return -1

gradeIDToString = (grade_id) ->
    grade_str = ["yellow", "green", "orange", "blue", "red", "white"]
    return grade_str[grade_id]


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

exports.loadActiveGradeBoulders = (req, res, next) ->
    grade_id = 0
    grade = req.params['grade']
    if grade is "green"
        grade_id = 1
    else if grade is "orange"
        grade_id = 2
    else if grade is "blue"
        grade_id = 3
    else if grade is "red"
        grade_id = 4
    else if grade is "white"
        grade_id = 5

    Boulder.find({ 'removed' : null, 'grade' : grade_id }).sort('date', '-1').exec (err, boulders) ->
        return renderError req, res, 500, { err } if err
        req.grade_boulders = boulders; next()

exports.loadBoulder = (req, res, next) ->
    boulder_id = req.params['boulder']
    Boulder.findOne { '_id' : boulder_id }, (err, boulder) ->
        return renderError req, res, 500, { err } if err or !boulder
        req.boulder = boulder; next()


# ----------------------------------------------------------------------------
# Show search result
# ----------------------------------------------------------------------------
#
exports.loadSearched = (req, res, next) ->
    if req.body.grade? and req.body.gradenr isnt ""
        Boulder.findOne { 'grade' : req.body.grade, 'gradenr' : req.body.gradenr}, (err, boulder) ->
            if boulder?.id
                res.redirect "/boulder/#{boulder.id}"
            else
                res.redirect "/search"
    else if req.body.grade?
        res.redirect "/stats/grade/#{gradeIDToString(req.body.grade)}"
    else
        res.redirect "/search"


# ----------------------------------------------------------------------------
# Actions on a boulder
# ----------------------------------------------------------------------------
#
exports.downgradeBoulder = (req, res, next) ->
    if req.body.secret is req.session?.auth_setter_secret
        if req.body.gradenr isnt ""
            if req.session.auth_setter_id and req.session.auth_setter_role is 'admin'
                Boulder.downgrade(req.params['boulder'], req.body.gradenr)
    next()

exports.upgradeBoulder = (req, res, next) ->
    if req.body.secret is req.session?.auth_setter_secret
        if req.body.gradenr isnt ""
            if req.session.auth_setter_id and req.session.auth_setter_role is 'admin'
                Boulder.upgrade(req.params['boulder'], req.body.gradenr)
    next()

exports.vote = (req, res, next) ->
    now = new Date()
    if req.session.next_vote < now.getTime() or not req.session.next_vote?
        new_seconds = now.getSeconds() + 10
        now.setSeconds new_seconds
        req.session.next_vote = now.getTime()
        Boulder.vote(req.params['boulder'], req.params['stars'])

    next()

exports.removeBoulder = (req, res, next) ->
    if req.session.auth_setter_id and req.body.secret is req.session?.auth_setter_secret
        Boulder.unscrew(req.params['boulder'])
    next()

exports.deleteBoulder = (req, res, next) ->
    if req.session.auth_setter_id and req.session.auth_setter_role is 'admin' and req.body.secret is req.session?.auth_setter_secret
        req.boulder.remove()
    next()


# ----------------------------------------------------------------------------
# Actions on a setter
# ----------------------------------------------------------------------------
#
exports.changePW = (req, res, next) ->
    if req.session.auth_setter_id? and req.body.newpw is req.body.newpw_check
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
    if req.session.auth_setter_id? and req.body.new_secret is req.body.new_secret_check
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
exports.loadSettersOfBoulder = (req, res, next) ->
    setters_ids = req.boulder.setters
    Setter.find { '_id': { $in : setters_ids } }, (err, setters) ->
        return renderError req, res, 500, { err } if err
        req.author_setters = setters; next()

exports.loadSetter = (req, res, next) ->
    setter_nickname = req.params['nickname']
    Setter.findOne { 'nickname':  setter_nickname }, (err, setter) ->
        return renderError req, res, 500, { err } if err or !setter
        req.setter = setter
        Boulder.find({ 'setters' : req.setter._id}).sort('date', '-1').exec (err, setter_boulders) ->
            return renderError req, res, 500, { err } if err
            req.setter_boulders = setter_boulders; next()

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
    if req.session.auth_setter_id?
        Setter.findOne { '_id':  req.session.auth_setter_id}, (err, setter) ->
            return renderError req, res, 500, { err } if err
            req.setter = setter
            Boulder.find({ 'setters' : req.setter._id}).sort('date', '-1').exec (err, setter_boulders) ->
                return renderError req, res, 500, { err } if err
                req.setter_boulders = setter_boulders; next()
    else
        res.redirect "/login"; next()


exports.createBoulder = (req, res, next) ->
    if req.body.secret is req.session?.auth_setter_secret
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
                    res.redirect '/profile'
                else
                    res.redirect '/boulder/' + boulder.id
    else
        res.redirect '/profile'


# ----------------------------------------------------------------------------
# TODO
# ----------------------------------------------------------------------------
#
exports.createSetter = (req, res, next) ->
    next()


