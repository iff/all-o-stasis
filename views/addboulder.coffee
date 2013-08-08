View      = require '../view'
settings  = require '../app/config-helper'

class AddBoulderView extends View

    setters: ->
        for setter in @req.setters
            setter

    errors: ->
        if @req.errors?
            return @req.errors
        else
            return []

    bouldername: ->
        if @req.body.name?
            return @req.body.name
        else
            return ""

    setternicknames: ->
        if @req.body.setter_nicks?
            if @req.body.setter_nicks instanceof Array
                return @req.body.setter_nicks
            else
                return [@req.body.setter_nicks]
        else
            return []

    grade: ->
        if @req.body.grade?
            return @req.body.grade
        else
            return -1

    grade_names: ->
        return settings.gradeNames()

    gradenr: ->
        if @req.body.gradenr?
            return @req.body.gradenr
        else
            return ""

    sector: ->
        if @req.body.sector?
            return @req.body.sector
        else
            return ""

    sectors: ->
        return settings.sectors()

    comments: ->
        if @req.body.comments?
            return @req.body.comments
        else
            return ""

module.exports = AddBoulderView
