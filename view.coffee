
{ _ } = require 'underscore'

class View

    @include: (name) ->
        mixin = require "./views/#{name}"
        @::[name] = method for name, method of mixin::

    # The constructor converts all instance methods into properties while
    # caching the method return value. This makes the object behave just like
    # a plain object with normal properties.
    constructor: (@req, @res) ->
        for key, value of @constructor.prototype
            continue if key == 'constructor' or View.prototype[key]
            Object.defineProperty @, key, get: _.once value.bind @

module.exports = View
