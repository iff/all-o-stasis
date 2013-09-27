View = require('../view')
{ gradeNames, gradeCSS } = require '../app/config-helper'

class BalanceView extends View

    expectedNrBoulder: ->
        return 180

    actualNrBoulders: ->
        return @req.boulders.length

    expectedDistribution: ->
        return [15, 20, 25, 20, 10, 10]

    actualDistribution: ->
        num_boulders = {}
        for name in gradeNames()
            num_boulders[name] = { val: 0, color: gradeCSS name }

        for boulder in @req.boulders
            num_boulders[boulder.grade].val += 1

        return num_boulders


module.exports = BalanceView
