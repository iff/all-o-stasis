View = require('../view')

class BalanceView extends View

    expectedNrBoulder: ->
        return 180

    actualNrBoulders: ->
        return @req.boulders.length

    expectedDistribution: ->
        return [15, 20, 25, 20, 10, 10]

    actualDistribution: ->
        num_boulders = [0, 0, 0, 0, 0, 0]
        for boulder in @req.boulders
            num_boulders[boulder.grade] += 1

        return num_boulders


module.exports = BalanceView
