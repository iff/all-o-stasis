mongoose = require 'mongoose'
module.exports = mongoose

mongoose.connect 'mongodb://localhost/minimum'

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
    setters : { type : [ ObjectID ], required : true                     },
    grade   : { type : String,       required : true                     },
    gradenr : { type : Number,       required : true                     },
    sector  : { type : Number,       required : true                     },
    date    : { type : Date,         required : false, default: Date.now },
    removed : { type : Date,         required : false, default: null     },
    stars   : { type : [ Number ],   required : false, default: []       },
    name    : { type : String,       required : false, default: ""       },
    comments: { type : [ String ],   requried : false, default: []       },
    addedBy : { type : ObjectID,     required : false                    }


BoulderSchema.statics =
    downgrade: (id, gradenr) ->
        Boulder.findOne { _id: id }, (err, boulder) ->
            current_grade = parseInt boulder.grade
            boulder.grade = Math.max(current_grade - 1, 0)
            boulder.gradenr = gradenr
            boulder.save()
            Setter.find { '_id': { $in : boulder.setters } }, (err, setters) ->
                for setter in setters
                    setter.gradingLevel = setter.gradingLevel + 1
                    setter.save()

    upgrade: (id, gradenr) ->
        Boulder.findOne { _id: id }, (err, boulder) ->
            current_grade = parseInt boulder.grade
            boulder.grade = Math.min(current_grade + 1, 5)
            boulder.gradenr = gradenr
            boulder.save()
            Setter.find { '_id': { $in : boulder.setters } }, (err, setters) ->
                for setter in setters
                    setter.gradingLevel = setter.gradingLevel - 1
                    setter.save()

    vote: (id, nr_stars) ->
        Boulder.update {_id: id}, {$push: {stars : nr_stars}}, (err, boulder) ->
            console.log err if err

    unscrew: (id) ->
        Boulder.findOne { _id: id }, (err, boulder) ->
            if not boulder.removed?
                boulder.removed = new Date()
                boulder.save()


mongoose.model 'boulder', BoulderSchema
Boulder = mongoose.model 'boulder'
