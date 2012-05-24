View = require('../view')

class AddBoulderView extends View

    setters: ->
        for setter in @req.setters
            setter

    errors: ->
        if @req.errors?
            return @req.errors
        else
            return []

    bouldername: ->
        if @req.body.name?
            return @req.body.name
        else
            return ""

    setternicknames: ->
        if @req.body.setter_nicks?
            if @req.body.setter_nicks instanceof Array
                return @req.body.setter_nicks
            else
                return [@req.body.setter_nicks]
        else
            return []

    grade: ->
        if @req.body.grade?
            return @req.body.grade
        else
            return -1

    grade_names: ->
        grades = []
        grades[0] = "Gelb   [1a  -- 4c]"
        grades[1] = "Gruen  [5a  -- 6a]"
        grades[2] = "Orange [6a+ -- 6b+]"
        grades[3] = "Blau   [6c  -- 7a]"
        grades[4] = "Rot    [7a+ -- 7b+]"
        grades[5] = "Weiss  [7c  -- ?]"
        return grades

    gradenr: ->
        if @req.body.gradenr?
            return @req.body.gradenr
        else
            return ""

    sector: ->
        if @req.body.sector?
            return @req.body.sector
        else
            return ""

    sectors: ->
        sectors = []
        sectors[0]  = "11 Block"
        sectors[1]  = "10"
        sectors[2]  = "9"
        sectors[3]  = "8 Platte"
        sectors[4]  = "7"
        sectors[5]  = "6 Bug"
        sectors[6]  = "5"
        sectors[7]  = "4"
        sectors[8]  = "3 Dach"
        sectors[9]  = "2"
        sectors[10] = "1"
        return sectors

    comments: ->
        if @req.body.comments?
            return @req.body.comments
        else
            return ""

module.exports = AddBoulderView
