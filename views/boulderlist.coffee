View = require('../view')
{ setterNicknames } = require '../app/helpers'
{ gradeCSS } = require '../app/config-helper'

class BoulderListView extends View

    shortMonth: (month) ->
        short     = []
        short[0]  = "JAN"
        short[1]  = "FEB"
        short[2]  = "MAR"
        short[3]  = "APR"
        short[4]  = "MAI"
        short[5]  = "JUN"
        short[6]  = "JUL"
        short[7]  = "AUG"
        short[8]  = "SEP"
        short[9]  = "OCT"
        short[10] = "NOV"
        short[11] = "DEZ"
        return short[month]

    list: ->
        for boulder in @req.boulders

            boulder.color = gradeCSS boulder.grade
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()

            likes    = 0
            dislikes = 0

            if boulder.likes?
                likes = boulder.likes
            if boulder.dislikes?
                dislikes = boulder.dislikes

            boulder.likes    = likes * 60    / (likes + dislikes)
            boulder.dislikes = dislikes * 60 / (likes + dislikes)

            boulder

module.exports = BoulderListView
