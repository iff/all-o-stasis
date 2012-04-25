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

