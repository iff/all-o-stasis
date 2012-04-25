View = require('../view')
{ setterNicknames, meanStarRating } = require '../app/helpers'

class BoulderListView extends View

    shortMonth: (month) ->
        short = []
        short[0] = "JAN"
        short[1] = "FEB"
        short[2] = "MAR"
        short[3] = "APR"
        short[4] = "MAI"
        short[5] = "JUN"
        short[6] = "JUL"
        short[7] = "AUG"
        short[8] = "SEP"
        short[9] = "OCT"
        short[10] = "NOV"
        short[11] = "DEZ"
        return short[month]

    list: ->
        for boulder in @req.boulders

            boulder.color = boulder.colorName()
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()
            boulder.mean_stars    = meanStarRating boulder

            boulder

module.exports = BoulderListView
