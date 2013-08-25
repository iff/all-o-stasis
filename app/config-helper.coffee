{ _ }  = require 'underscore'
config = require '../config'


# Grade stuff

exports.gradeNames = () ->
    return Object.keys config.grades

exports.gradeValue = (grade_name) ->
    return config.grades[grade_name]

exports.gradeCSS = (grade_id) ->
    return config.gradeCSSClass[grade_id]



# Sector stuff

exports.sectors = () ->
    return Object.keys config.sectors

exports.sectorImage = (sector_name) ->
    if isNaN sector_name
        return config.sectors[sector_name]
    else
        name = Object.keys(config.sectors)[parseInt(sector_name)]
        return config.sectors[name]


