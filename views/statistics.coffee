View = require('../view')
{ setterNicknames, computeBayesianRating } = require '../app/helpers'
{ _ } = require 'underscore'

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

    top10: ->
        top = computeBayesianRating @req.boulders

        if top.length is 0
            return null

        top_ten = _.first(top, 10)

        for topb in top_ten
            topb.color         = topb.colorName()
            topb.prettySetters = setterNicknames topb.setters, @req.setters
            topb.prettyDate    = topb.formattedDate()
            topb.num_rating    = topb.bayesian_rating

            topb

module.exports = IndexView
