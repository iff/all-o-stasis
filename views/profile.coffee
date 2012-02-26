{ _ } = require('underscore')
View = require('../view')

class ProfileView extends View

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

    bouldersThisMonth: ->
        num_this_month = 0
        now = new Date()
        this_month = now.getMonth()
        this_year  = now.getFullYear()
        for boulder in @req.setter_boulders
            if boulder.date.getMonth() is this_month and boulder.date.getFullYear() is this_year
                num_this_month += 1

        return num_this_month


    percentMinimumBoulders: ->
        total = @req.boulders.length
        total_own = 1
        for boulder in @req.setter_boulders
            if boulder.removed is null
                total_own += 1
        return parseInt(total_own/total * 100)

    thisMonth: ->
        now = new Date()
        month = []
        month[0]="Januar"
        month[1]="Februar"
        month[2]="Maerz"
        month[3]="April"
        month[4]="Mai"
        month[5]="Juni"
        month[6]="July"
        month[7]="August"
        month[8]="September"
        month[9]="October"
        month[10]="November"
        month[11]="Dezember"
        return month[now.getMonth()]

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
            boulder.prettyDate = boulder.date.getDate() + "." + month + "." + boulder.date.getFullYear()

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

module.exports = ProfileView
