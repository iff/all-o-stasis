View     = require('../view')
settings = require '../config'

class TeamView extends View

    numMonthlyBoulders: ->
        return settings.numMonthlyBoulders

    team: ->
        for setter in @req.setters
            num_boulders_up      = 0
            monthly_table        = {}

            now   = new Date()
            year  = now.getFullYear()
            month = 1

            setter.first_date = [month, year].join('.')

            for i in [1..12]
                date_str = [ month, year ].join('.')

                monthly_table[date_str] = 0
                month += 1

            setter.last_date = [month-1, year].join('.')

            for boulder in @req.all_boulders
                if boulder.setters.indexOf(setter.id) isnt -1
                    date_str = [ boulder.date.getMonth() + 1
                            , boulder.date.getFullYear()
                            ].join('.')

                    if monthly_table[date_str] >= 0
                        monthly_table[date_str] += 1

                    if not boulder.removed?
                        num_boulders_up += 1

            setter.monthlyTable    = monthly_table
            setter.num_boulders_up = num_boulders_up

            setter


module.exports = TeamView
