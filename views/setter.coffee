View = require '../view'

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

            if boulder.grade is '0'
                boulder.color = "yellow"
            else if boulder.grade is '1'
                boulder.color = "green"
            else if boulder.grade is '2'
                boulder.color = "orange"
            else if boulder.grade is '3'
                boulder.color = "blue"
            else if boulder.grade is '4'
                boulder.color = "red"
            else if boulder.grade is '5'
                boulder.color = "white"
            else
                console.log "ERROR GRADE"

            setters = ""
            for setter in boulder.setters
                for fs in @req.setters
                    if "#{setter}" == "#{fs.id}"
                        setters += fs.nickname + " "

            boulder.prettySetters = setters

            month = boulder.date.getMonth() + 1
            if month < 10
                month = '0' + month
            day = boulder.date.getDate()
            if day < 10
                day = '0' + day
            boulder.prettyDate = day + "." + month + "." + boulder.date.getFullYear()

            num_stars = 0
            sum_stars = 0
            for star in boulder.stars
                num_stars += 1
                sum_stars += star

            if num_stars is 0
                boulder.mean_stars = ""
            else
                star_str = ""
                for star in [1..Math.round(sum_stars / num_stars)]
                    star_str += "*"
                boulder.mean_stars = star_str

            boulder

module.exports = SetterView
