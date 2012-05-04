View = require '../view'
{ setterNicknames, meanStarRating } = require '../app/helpers'

Futures = require 'futures'

db = require '../database'
Setter = db.model 'setter'

class SetterView extends View

    setter: ->
        return @req.setter

    name: ->
        return @req.setter.name

    nickname: ->
        return @req.setter.nickname

    avatar: ->
        return '/avatars/' + @req.setter.nickname + '.jpg'

    grading: ->
        console.log @req.setter.gradingLevel
        if @req.setter.gradingLevel > 5
            return 'oft zu schwer'
        else if @req.setter.gradingLevel < -5
            return 'oft zu leicht'
        else if @req.setter.gradingLevel > 0
            return 'gelegentlich zu schwer'
        else if @req.setter.gradingLevel < 0
            return 'gelegentlich zu leicht'
        else
            return 'genau richtig'

    totalBoulders: ->
        return @req.setter_boulders.length

    maxBoulder: ->
        boulders_per_grade = [0,0,0,0,0,0]
        for boulder in @req.setter_boulders
            boulders_per_grade[boulder.grade] += 1

        max = 0
        for idx in [0..boulders_per_grade.length]
            if boulders_per_grade[idx] > max
                max = boulders_per_grade[idx]

        return max

    histogram: ->
        boulders_per_grade = [0,0,0,0,0,0]
        for boulder in @req.setter_boulders
            boulders_per_grade[boulder.grade] += 1

        return boulders_per_grade


    boulders: ->
        for boulder in @req.setter_boulders

            boulder.color = boulder.colorName()
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()
            boulder.mean_stars    = meanStarRating boulder

            boulder

module.exports = SetterView
