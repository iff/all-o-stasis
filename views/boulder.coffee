View = require '../view'

Futures = require 'futures'

db = require '../database'
Setter = db.model 'setter'

class BoulderView extends View

    boulder: ->
        return @req.boulder

    name: ->
        return @req.boulder.name

    hasName: ->
        return @req.boulder.name?

    gradeNr: ->
        return @req.boulder.gradenr

    date: ->
        return @req.boulder.date

    grade: ->
        return @req.boulder.grade

    gradeName: ->
        if @req.boulder.grade is '0'
            return "yellow"
        else if @req.boulder.grade is '1'
            return "green"
        else if @req.boulder.grade is '2'
            return "orange"
        else if @req.boulder.grade is '3'
            return "blue"
        else if @req.boulder.grade is '4'
            return "red"
        else if @req.boulder.grade is '5'
            return "white"

    gradeTag: ->
        if @req.boulder.grade is '0'
            return "gelb_#{@req.boulder.gradenr}"
        else if @req.boulder.grade is '1'
            return "gruen_#{@req.boulder.gradenr}"
        else if @req.boulder.grade is '2'
            return "orange_#{@req.boulder.gradenr}"
        else if @req.boulder.grade is '3'
            return "blau_#{@req.boulder.gradenr}"
        else if @req.boulder.grade is '4'
            return "rot_#{@req.boulder.gradenr}"
        else if @req.boulder.grade is '5'
            return "weiss_#{@req.boulder.gradenr}"

    sector: ->
        return @req.boulder.sector

    totalStars: ->
        return 0

    starsCount: ->
        count = [0,0,0]
        return count
        for star in @req.boulder.stars
            count[star-1] += 1
        return count

    hasBeenRemoved: ->
        return @req.boulder.removed?

    removeDate: ->
        return @req.boulder.removed

    setters: ->
        return @req.author_setters

    comments: ->
        return @req.boulder.comment

module.exports = BoulderView
