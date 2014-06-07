View      = require '../view'
settings  = require '../app/config-helper'

class AddBoulderView extends View

    errors: ->
        if @req.errors?
            return @req.errors
        else
            return []

    removed: ->
        if @req.removed?
            return @req.removed
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

module.exports = AddBoulderView
