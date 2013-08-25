View = require('../view')
{ setterNicknames, computeBayesianRating } = require '../app/helpers'
{ gradeNames, gradeCSS } = require '../app/config-helper'
{ _ } = require 'underscore'

class IndexView extends View

    titleStat: -> 'Statistics'

    totalBoulders: ->
        return @req.boulders.length

    trend: ->
        {}

    histogram: ->
        percentages = {}
        for name in gradeNames()
            percentages[name] = { val: 0, color: gradeCSS name }

        for boulder in @req.boulders
            percentages[boulder.grade].val += 1

        return percentages

    top10: ->
        top = computeBayesianRating @req.boulders

        if top.length is 0
            return null

        top_ten = _.first(top, 10)

        for topb in top_ten
            topb.color         = gradeCSS topb.grade
            topb.prettySetters = setterNicknames topb.setters, @req.setters
            topb.prettyDate    = topb.formattedDate()
            topb.num_rating    = topb.bayesian_rating

            topb

module.exports = IndexView
