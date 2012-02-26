View = require('../view')

class AddBoulderView extends View

    setters: ->
        for setter in @req.setters
            setter

module.exports = AddBoulderView
