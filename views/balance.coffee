View = require('../view')

class BalanceView extends View

    expectedNrBoulder: ->
        return 180

    actualNrBoulders: ->
        return @req.boulders.length

    expectedDistribution: ->
        return [15, 20, 25, 20, 10, 10]

    actualDistribution: ->
        percentages = [0, 0, 0, 0, 0, 0]
        for boulder in @req.boulders
            percentages[boulder.grade] += 1

        percentages = percentages,map((x) -> x / @req.boulders.length * 100)
        return percentages


module.exports = BalanceView
