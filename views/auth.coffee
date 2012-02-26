
class Mixin

    isAuth: ->
        return @req.session.auth_setter_id?

    authSetterName: ->
        return @req.session?.auth_setter_name

    authSetterRole: ->
        return @req.session?.auth_setter_role

    authSetterSecret: ->
        return @req.session?.auth_setter_secret

module.exports = Mixin
