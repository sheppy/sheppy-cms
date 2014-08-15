
express = require "express"

router = express.Router()

router.get "/test", (req, res) ->
    res.send "some json"

###
app.get "/", (req, res, next) ->
    Page.findByUrl "/homepage", (err, page) ->
        if err then return next(err)
        CMS.renderCmsPage err, res, page, next
###

module.exports = router