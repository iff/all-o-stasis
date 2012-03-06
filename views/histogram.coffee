View = require('../view')

class IndexView extends View

    totalBoulders: ->
        return @req.boulders.length

    histogram: ->
        percentages = [0, 0, 0, 0, 0, 0]
        for boulder in @req.boulders
            percentages[boulder.grade] += 1

        return percentages

module.exports = IndexView
