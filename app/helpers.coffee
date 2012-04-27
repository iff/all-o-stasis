# some helper functions

findSetterNick = (setter_id, setters) ->
    for fs in setters
        if "#{setter_id}" == "#{fs.id}"
            return fs.nickname

    return null


exports.setterNicknames = (ids, setters) ->
    ids.map((id) -> findSetterNick(id, setters)).filter((nick) -> nick isnt null)


exports.meanStarRating = (boulder) ->
    if boulder.stars.length is 0
        return ""
    else
        return [1..Math.round(boulder.rating())].map((x) -> '*').join('')


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

