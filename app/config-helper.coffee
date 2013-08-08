{ _ }  = require 'underscore'
config = require '../config'


# Grade stuff

exports.fromGradeID = (grade_id) ->
   return gradeNames[grade_id]

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
    return config.sectors[sector_name]



