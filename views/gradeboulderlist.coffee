View = require('../view')

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

            setters = []
            for setter in boulder.setters
                for fs in @req.setters
                    if "#{setter}" == "#{fs.id}"
                        setters.push(fs.nickname)
            #for setter in @req.bs[boulder.id]
                #setters += setter.nickname + " "
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

module.exports = GradeBoulderListView
