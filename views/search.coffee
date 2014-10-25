View     = require('../view')
settings = require '../app/config-helper'

class SearchView extends View

    errorMsg: ->
        if @req.error_msg
            return @req.error_msg
        else
            return ""

    grade_names: ->
        return settings.gradeNames()

    sectors: ->
        secs = [""]
        return secs.concat settings.sectors()


module.exports = SearchView
