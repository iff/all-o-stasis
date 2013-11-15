{ _ } = require('underscore')
View = require('../view')

{ setterNicknames } = require '../app/helpers'
{ gradeNames, gradeCSS } = require '../app/config-helper'
config = require '../config'

class ProfileView extends View

    setter: ->
        return @req.setter

    name: ->
        return @req.setter.name

    nickname: ->
        return @req.setter.nickname

    avatar: ->
        return '/avatars/' + @req.setter.nickname + '.jpg'

    boulders: ->
        return @req.setter_boulders

    totalBoulders: ->
        return @req.setter_boulders.length

    maxBoulder: ->
        boulders_per_grade = {}
        for name in gradeNames()
            boulders_per_grade[name] = 0

        for boulder in @req.setter_boulders
            boulders_per_grade[boulder.grade] += 1

        max = 0
        for val of boulders_per_grade
            if boulders_per_grade[val] > max
                max = boulders_per_grade[val]

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

    targetThisMonth: ->
        return config.numMonthlyBoulders

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
        percentages = {}
        for name in gradeNames()
            percentages[name] = { val: 0, color: gradeCSS name }

        for boulder in @req.setter_boulders
            if boulder.removed is null
                percentages[boulder.grade].val += 1

        return percentages



module.exports = ProfileView
