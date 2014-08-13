Page = require "./models/Page"


renderCmsPage = module.exports.renderCmsPage = (err, res, page, next, model = {}) ->
    if (err) then return next(err) # 500
    if !page then return next() # 404

    model.title ?= page.title
    model.metaDescription ?= page["meta-description"]
    model.page ?= page

    res.render "templates/#{page.template}", model


# This needs to happen at the end
module.exports.initRoute = (app) ->
    app.get "*", (req, res, next) ->
        # Skip assets
        if /\/assets\//.test req.path then return next()

        Page.findByUrl req.path, (err, page) ->
            renderCmsPage err, res, page, next