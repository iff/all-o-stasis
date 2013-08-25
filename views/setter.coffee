View = require '../view'
{ setterNicknames, computeBayesianRating} = require '../app/helpers'
{ gradeCSS } = require '../app/config-helper'
{ _ } = require 'underscore'

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

    topBoulder: ->
        active = []

        for boulder in @req.setter_boulders
            if not boulder.removed?
                active.push(boulder)

        top = computeBayesianRating(active)

        top_boulder = (_.first(top, 1))[0]
        if top_boulder? and top_boulder.bayesian_rating > -10000
            top_boulder.color = top_boulder.colorName()
            return top_boulder
        else
            return null


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

            boulder.color = gradeCSS boulder.grade
            boulder.prettySetters = setterNicknames boulder.setters, @req.setters
            boulder.prettyDate    = boulder.formattedDate()

            boulder

module.exports = SetterView
