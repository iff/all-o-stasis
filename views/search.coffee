View     = require('../view')
settings = require '../app/config-helper'

class SearchView extends View

    errorMsg: ->
        if @req.error_msg
            return @req.error_msg
        else
            return ""

    grade_names: ->
        console.log settings.gradeNames()
        return settings.gradeNames()


module.exports = SearchView
