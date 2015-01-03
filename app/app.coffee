{ _ } = require 'underscore'

templateLocals = (req, res, viewName) ->
    viewHelperClass = require("#{__dirname}/../views/#{viewName}")
    return new viewHelperClass req, res

exports.renderTwoColumn = (req, res, leftViewName, rightViewName) ->
    left   = templateLocals req, res, leftViewName
    right  = templateLocals req, res, rightViewName
    header = templateLocals req, res, 'header'

    locals =
        leftPartialName   :  leftViewName,
        rightPartialName  :  rightViewName,
        headerPartialName :  'header'
    res.locals = _.extend res.locals, left, right, header
    res.render 'twocolumn', locals

exports.renderError = (req, res, errornr, error) ->
    header = templateLocals req, res, 'header'
    locals = _.extend header, {errornr: errornr, error: error}
    res.render 'error', locals

exports.renderHistogram = (req, res) ->
    locals = templateLocals req, res, 'histogram'
    res.render 'histogram', locals

