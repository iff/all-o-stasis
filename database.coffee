mongoose = require 'mongoose'
module.exports = mongoose
settings = require './config'

{nextLowerGrade, nextHigherGrade} = require './app/config-helper'

mongoose.connect 'mongodb://localhost/' + settings.databaseName

Schema = mongoose.Schema
ObjectID = Schema.ObjectId

SetterSchema = new Schema
    email       : { type : String, required : true,  unique : true     },
    name        : { type : String, required : true                     },
    role        : { type : String, required : true,  default: 'setter' },
    password    : { type : String, required : true                     },
    nickname    : { type : String, required : true,  unique : true     },
    secret      : { type : String, required : true                     },
    gradingLevel: { type : Number, required : false, default: 0        }


SetterSchema.statics =
    auth: (nickname, password, callback) ->
        Setter.findOne { nickname: nickname.toUpperCase() }, (err, setter) ->
            if setter and password is setter.password
                callback null, setter
            else
                callback new Error 'Setter not found'

    nicksToSetterIDs: (setter_nicks, callback) ->
        Setter.find { 'nickname': { $in : setter_nicks } }, (err, setters) ->
            ids = []
            for setter in setters
                ids.push setter._id

            callback null, ids


mongoose.model 'setter', SetterSchema
Setter = mongoose.model 'setter'


BoulderSchema = new Schema
    setters    : { type : [ ObjectID ], required : true                     },
    grade      : { type : String,       required : true                     },
    gradenr    : { type : Number,       required : true                     },
    sector     : { type : String,       required : true                     },
    date       : { type : Date,         required : false, default: Date.now },
    removed    : { type : Date,         required : false, default: null     },
    likes      : { type : Number,       required : false, default: 0        },
    dislikes   : { type : Number,       required : false, default: 0        },
    name       : { type : String,       required : false, default: ""       },
    comments   : { type : [ String ],   requried : false, default: []       },
    addedBy    : { type : ObjectID,     required : false                    },
    grade_vote : [ {name:  {type: String, required: true}, count: {type: Number, required: true, default: 0} } ]


BoulderSchema.statics =
    downgrade: (id, gradenr) ->
        Boulder.findOne { _id: id }, (err, boulder) ->
            boulder.grade   = nextLowerGrade boulder.grade
            boulder.gradenr = gradenr
            boulder.save()
            Setter.find { '_id': { $in : boulder.setters } }, (err, setters) ->
                for setter in setters
                    setter.gradingLevel = setter.gradingLevel + 1
                    setter.save()

    upgrade: (id, gradenr) ->
        Boulder.findOne { _id: id }, (err, boulder) ->
            boulder.grade   = nextHigherGrade boulder.grade
            boulder.gradenr = gradenr
            boulder.save()
            Setter.find { '_id': { $in : boulder.setters } }, (err, setters) ->
                for setter in setters
                    setter.gradingLevel = setter.gradingLevel - 1
                    setter.save()

    like: (id) ->
        Boulder.update {_id: id}, {$inc: {likes : 1}}, (err, boulder) ->
            console.log err if err

    dislike: (id) ->
        Boulder.update {_id: id}, {$inc: {dislikes : 1}}, (err, boulder) ->
            console.log err if err

    vote_grade: (id, grade) ->
        Boulder.update {_id: id, 'grade_vote.name': "#{grade}"}, {$inc: {"grade_vote.$.count" : 1}}, (err, boulder) ->
            console.log err if err
            if err or boulder is 0
                Boulder.update {_id : id}, {$push: {'grade_vote' : {'name': grade, 'count': 1}}}, (err, boulder) ->
                    console.log err if err

    unscrew: (id) ->
        Boulder.findOne { _id: id }, (err, boulder) ->
            if not boulder.removed?
                boulder.removed = new Date()
                boulder.save()


BoulderSchema.methods =
    rating: ->
        return @likes - @dislikes

    colorName: ->
        switch @grade
            when '0' then 'yellow'
            when '1' then 'green'
            when '2' then 'orange'
            when '3' then 'blue'
            when '4' then 'red'
            when '5' then 'white'
            else          'unknown'

    formattedDate: ->
         pad = (n) -> n < 10 and '0' + n or n

         [ pad(@date.getDate())
         , pad(@date.getMonth() + 1)
         ,     @date.getFullYear()
         ].join '.'



mongoose.model 'boulder', BoulderSchema
Boulder = mongoose.model 'boulder'
