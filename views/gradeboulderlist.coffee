View = require('../view')

findSetterNick = (setter_id, setters) ->
    for fs in setters
        if "#{setter_id}" == "#{fs.id}"
            return fs.nickname

    return null

setterNicknames = (ids, setters) ->
    ids.map((id) -> findSetterNick(id, setters)).filter((nick) -> nick isnt null)

meanStarRating = (boulder) ->
    if boulder.stars.length is 0
        return ""
    else
        return [1..Math.round(boulder.rating())].map((x) -> '*').join('')

class GradeBoulderListView extends View

    gradeName: ->
        boulder = @req.grade_boulders[0]
        if boulder.grade is '0'
            boulder.color = "Gelbe"
        else if boulder.grade is '1'
            boulder.color = "Gruene"
        else if boulder.grade is '2'
            boulder.color = "Orange"
        else if boulder.grade is '3'
            boulder.color = "Blaue"
        else if boulder.grade is '4'
            boulder.color = "Rote"
        else if boulder.grade is '5'
            boulder.color = "Weisse"

    grade_list: ->
        for boulder in @req.grade_boulders

            boulder.color         = boulder.colorName()
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()
            boulder.mean_stars    = meanStarRating boulder

            boulder

module.exports = GradeBoulderListView
