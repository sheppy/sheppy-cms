express = require "express"
assets = require "connect-assets"

SheppyApp = require "../src/App"
SheppyDatabase = require "../src/Database"


class ExampleApp extends SheppyApp
    paths:
        docroot: "#{__dirname}/public"
        assets: "#{__dirname}/public/assets"
        routes: "#{__dirname}/routes"
        views: "#{__dirname}/views"

    configureGeneral: ->
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


database = new SheppyDatabase
database.connect()

exampleApp = new ExampleApp
exampleApp.init()
exampleApp.start()