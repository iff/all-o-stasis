View = require('../view')

class BoulderListView extends View

    shortMonth: (month) ->
        short = []
        short[0] = "JAN"
        short[1] = "FEB"
        short[2] = "MAR"
        short[3] = "APR"
        short[4] = "MAI"
        short[5] = "JUN"
        short[6] = "JUL"
        short[7] = "AUG"
        short[8] = "SEP"
        short[9] = "OCT"
        short[10] = "NOV"
        short[11] = "DEZ"
        return short[month]

    list: ->
        for boulder in @req.boulders

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

            boulder.prettySetters = setters

            month = boulder.date.getMonth() + 1
            if month < 10
                month = '0' + month
            day = boulder.date.getDate()
            if day < 10
                day = '0' + day
            boulder.prettyDate = day + "." + month + "." + boulder.date.getFullYear()

            #boulder.year = boulder.date.getFullYear()
            #boulder.prettyDate = shortMonth(month) + " " + day

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

module.exports = BoulderListView
