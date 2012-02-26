View = require('../view')

class IndexView extends View

    titleStat: -> 'Statistics'

    totalBoulders: ->
        return @req.boulders.length

    trend: ->
        {}

    histogram: ->
        percentages = [0, 0, 0, 0, 0, 0]
        for boulder in @req.boulders
            percentages[boulder.grade] += 1

        return percentages

module.exports = IndexView
