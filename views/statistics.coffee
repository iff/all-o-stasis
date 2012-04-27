View = require('../view')
{ setterNicknames, meanStarRating } = require '../app/helpers'
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

    top5: ->
        top = _.values(@req.boulders).sort (lhs, rhs) ->
            sort_stars = rhs.rating() - lhs.rating()
            return sort_stars unless sort_stars is 0
            # sorting according to number of votes
            return rhs.stars.length - lhs.stars.length

        top_five = _.first(top, 5)

        for boulder in top_five
            boulder.color = boulder.colorName()
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()
            boulder.mean_stars    = meanStarRating boulder

            boulder

module.exports = IndexView
