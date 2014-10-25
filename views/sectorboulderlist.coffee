View = require('../view')
{ setterNicknames } = require '../app/helpers'
{ gradeCSS } = require '../app/config-helper'

class SectorBoulderListView extends View

    sectorName: ->
        if @req.grade_boulders[0]
            return @req.grade_boulders[0].sector
        else
            return ""

    boulder_list: ->
        for boulder in @req.grade_boulders

            boulder.color         = gradeCSS boulder.grade
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()

            boulder

module.exports = SectorBoulderListView
