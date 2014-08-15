express = require "express"
router = express.Router()

# Add an example test custom route
router.get "/test", (req, res) ->
    res.send "This is a test response - you could also use templates"

module.exports = router