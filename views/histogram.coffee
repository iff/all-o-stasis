View = require('../view')
{ gradeNames, gradeCSS } = require '../app/config-helper'

class IndexView extends View

    totalBoulders: ->
        return @req.boulders.length

    histogram: ->
        percentages = {}
        for name in gradeNames()
            percentages[name] = { val: 0, color: gradeCSS name }

        for boulder in @req.boulders
            percentages[boulder.grade].val += 1

        return percentages

module.exports = IndexView
