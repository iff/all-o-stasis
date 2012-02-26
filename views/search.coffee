View = require('../view')

class SearchView extends View

    errorMsg: ->
        if @req.error_msg
            return @req.error_msg
        else
            return ""

module.exports = SearchView
