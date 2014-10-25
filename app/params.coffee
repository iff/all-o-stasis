
{ renderTwoColumn, renderError } = require './app'

db      = require('../database')
Setter  = db.model('setter')
Boulder = db.model('boulder')


app.param 'boulder', (req, res, next, boulder_id) ->
    Boulder.findById boulder_id, (err, boulder) ->
        return renderError req, res, 500, { err } if err or !boulder
        req.boulder = boulder

        setters_ids = req.boulder.setters
        Setter.find { '_id': { $in : setters_ids } }, (err, setters) ->
            return renderError req, res, 500, { err } if err
            req.author_setters = setters; next()


app.param 'grade', (req, res, next, grade_name) ->
    Boulder.find({ 'removed' : null, 'grade' : grade_name }).sort({date: -1}).exec (err, boulders) ->
        return renderError req, res, 500, { err } if err
        req.grade_boulders = boulders; next()

app.param 'sector', (req, res, next, sector_name) ->
    Boulder.find({ 'removed' : null, 'sector' : sector_name}).sort({date: -1}).exec (err, boulders) ->
        return renderError req, res, 500, { err } if err
        req.grade_boulders = boulders; next()

app.param 'nickname', (req, res, next, nickname) ->
    Setter.findOne { 'nickname':  nickname }, (err, setter) ->
        return renderError req, res, 500, { err } if err or !setter
        req.setter = setter

        Boulder.find({ 'setters' : req.setter._id}).sort({date: -1}).exec (err, setter_boulders) ->
            return renderError req, res, 500, { err } if err
            req.setter_boulders = setter_boulders; next()

