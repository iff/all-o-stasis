View = require('../view')
{ setterNicknames } = require '../app/helpers'

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

            boulder

module.exports = GradeBoulderListView
