View = require('../view')
{ setterNicknames, bayesianRating } = require '../app/helpers'
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
        num_boulders_with_votes = 0
        sum_votes = 0
        sum_ratings = 0
        for boulder in @req.boulders
            if boulder.stars.length isnt 0
                sum_votes += boulder.stars.length
                sum_ratings += boulder.rating()
                num_boulders_with_votes += 1

        avg_votes = sum_votes / num_boulders_with_votes
        avg_ratings = sum_ratings / num_boulders_with_votes

        top = _.values(@req.boulders).sort (lhs, rhs) ->
            sort_stars = bayesianRating(rhs, avg_votes, avg_ratings) - bayesianRating(lhs, avg_votes, avg_ratings)

        top_ten = _.first(top, 10)

        for topb in top_ten
            topb.color = topb.colorName()
            topb.prettySetters = setterNicknames topb.setters, @req.setters
            topb.prettyDate    = topb.formattedDate()
            topb.num_rating    = (bayesianRating(topb, avg_votes, avg_ratings)).toFixed(2)

            topb

module.exports = IndexView
