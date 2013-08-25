View = require('../view')
{ setterNicknames } = require '../app/helpers'
{ gradeCSS } = require '../app/config-helper'

class GradeBoulderListView extends View

    gradeName: ->
        boulder = @req.grade_boulders[0].grade

    grade_list: ->
        for boulder in @req.grade_boulders

            boulder.color         = gradeCSS boulder.grade
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()

            boulder

module.exports = GradeBoulderListView
