View = require '../view'

Futures = require 'futures'

db = require '../database'
Setter = db.model 'setter'

{ sectorImage } = require '../app/config-helper'

class BoulderView extends View

    errors: ->
        if @req.errors?
            return @req.errors
        else
            return []

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
        return sectorImage @req.boulder.sector

    likes: ->
        if @req.boulder.likes?
            return @req.boulder.likes
        else
            return 0

    likesPixels: ->
        return @likes * 100 / (@likes + @dislikes)

    dislikes: ->
        if @req.boulder.dislikes?
            return @req.boulder.dislikes
        else
            return 0

    dislikesPixels: ->
        return @dislikes * 100 / (@likes + @dislikes)

    hasBeenRemoved: ->
        return @req.boulder.removed?

    removeDate: ->
        return @req.boulder.removed

    setters: ->
        return @req.author_setters

    comments: ->
        return @req.boulder.comment

module.exports = BoulderView
