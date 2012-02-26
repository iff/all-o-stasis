View = require('../view')

class TeamView extends View

    team: ->
        for setter in @req.setters

            num_this_month = 0
            num_total = 0
            now = new Date()
            this_month = now.getMonth()
            this_year  = now.getFullYear()
            for boulder in @req.all_boulders
                if boulder.setters.indexOf(setter.id) isnt -1
                    num_total += 1
                    if boulder.date.getMonth() is this_month and boulder.date.getFullYear() is this_year
                        num_this_month += 1

            setter.num_this_month = num_this_month
            setter.num_total = num_total

            setter

module.exports = TeamView
