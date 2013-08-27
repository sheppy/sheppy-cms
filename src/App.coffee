fs = require "fs"
express = require "express"
http = require "http"
assets = require "connect-assets"
Log = require("./Log").SheppyCMS.Log


root = exports ? this

root.SheppyCMS ?= {}

class root.SheppyCMS.App
    app: null
    defaultPort: 3000
    paths:
        docroot: "#{__dirname}/../public"
        assets: "#{__dirname}/../public/assets"
        routes: "#{__dirname}/../routes"
        views: "#{__dirname}/../views"


    init: ->
        @app = express()
        @app.configure "development", => @configureDevevlopment()
        @app.configure "production", => @configureProduction()
        @app.configure => @configureAll()


    configureAll: ->
        @app.set "port", process.env.PORT || @defaultPort
        @app.set "views", @paths.views
        @app.set "view engine", "jade"
        @app.use express.bodyParser()
        @app.use express.methodOverride()
        @app.use @app.router

        @app.use assets {
            build: true
            src: @paths.docroot
            buildDir: @paths.assets
        }

        @app.use express["static"](@paths.docroot)

        @loadRoutes()
        @addCmsRoute()
        @add404Route()
        @add500Route()


    configureDevevlopment: ->
        @app.use express.logger("dev")
        @app.use express.errorHandler { dumpExceptions: true, showStack: true }


    configureProduction: ->
        @app.use express.errorHandler()


    start: ->
        http.createServer(@app).listen(@app.get("port"), () =>
            Log.success "Express", "server listening on port #{@app.get("port")}"
        )


    # Automatically include all of our routes
    loadRoutes: ->
        fs.readdirSync(@paths.routes).forEach (filename) =>
            @app.use require("#{@paths.routes}/#{filename}")(@app)


    addCmsRoute: ->
        @app.use (req, res, next) =>
            # TODO: Look up the page in the CMS
            return next()


    add404Route: ->
        @app.use (req, res) ->
            res.status 404
            res.render "errors/404", {
                title: "Page not found"
                status: 404
                url: req.url
            }


    add500Route: ->
        @app.use (err, req, res, next) =>
            res.status 500
            res.render "errors/500", {
                title: "Server error"
                status: err.status || 500
                error: err if @app.settings.env == "development"
            }