{ _ }  = require 'underscore'
config = require '../config'


# Grade stuff

exports.gradeNames = () ->
    return Object.keys config.grades

exports.gradeValue = (grade_name) ->
    return config.grades[grade_name]

exports.gradeCSS = (grade_id) ->
    return config.gradeCSSClass[grade_id]

exports.nextLowerGrade = (grade_name) ->
    grades = Object.keys config.grades
    idx = parseInt(grades.indexOf grade_name)
    idx = Math.max idx - 1, 0
    return grades[idx]

exports.nextHigherGrade = (grade_name) ->
    grades = Object.keys config.grades
    idx = parseInt(grades.indexOf grade_name)
    idx = Math.min idx + 1, grades.length
    return grades[idx]

# Sector stuff

exports.sectors = () ->
    return Object.keys config.sectors

exports.sectorImage = (sector_name) ->
    if isNaN sector_name
        return config.sectors[sector_name]
    else
        name = Object.keys(config.sectors)[parseInt(sector_name)]
        return config.sectors[name]


