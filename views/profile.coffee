{ _ } = require('underscore')
View = require('../view')
{ setterNicknames } = require '../app/helpers'

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


module.exports = ProfileView
