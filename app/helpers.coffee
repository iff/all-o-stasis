{ _ } = require 'underscore'

# some helper functions

findSetterNick = (setter_id, setters) ->
    for fs in setters
        if "#{setter_id}" == "#{fs.id}"
            return fs.nickname

    return null

bayesianRating = (boulder, avg_votes, avg_ratings) ->
    if (boulder.likes < 1) and (boulder.dislikes < 1)
        #FIXME
        boulder.bayesian_rating = -100000
    else
        my_votes = boulder.likes + boulder.dislikes
        my_ratings = boulder.rating()

        boulder.bayesian_rating = ((avg_votes * avg_ratings) +
            (my_votes * my_ratings)) / (avg_votes + my_votes)

    return boulder.bayesian_rating



exports.setterNicknames = (ids, setters) ->
    ids.map((id) -> findSetterNick(id, setters)).filter((nick) -> nick isnt null)


exports.fromGradeID = (grade_id) ->
    grade_str = ["yellow", "green", "orange", "blue", "red", "white"]
    return grade_str[grade_id]


exports.fromGradeName = (grade_name) ->
    switch grade_name
        when 'yellow' then 0
        when 'green'  then 1
        when 'orange' then 2
        when 'blue'   then 3
        when 'red'    then 4
        when 'white'  then 5
        else               -1

exports.computeBayesianRating = (boulders) ->
        num_boulders_with_votes = 0
        sum_votes = 0
        sum_ratings = 0
        for boulder in boulders
            if boulder.likes > 0 or boulder.dislikes > 0
                sum_votes += boulder.likes + boulder.dislikes
                sum_ratings += boulder.rating()
                num_boulders_with_votes += 1

        avg_votes = sum_votes / num_boulders_with_votes
        avg_ratings = sum_ratings / num_boulders_with_votes

        rated = _.values(boulders).sort (lhs, rhs) ->
            bayesianRating(rhs, avg_votes, avg_ratings) -
            bayesianRating(lhs, avg_votes, avg_ratings)

        return rated

