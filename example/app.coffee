express = require "express"
assets = require "connect-assets"

SheppyApp = require "../src/App"
SheppyDatabase = require "../src/Database"


class ExampleApp extends SheppyApp
    secretKey: "example-app"
    paths:
        docroot: "#{__dirname}/public"
        assets: "#{__dirname}/public/assets"
        routes: "#{__dirname}/routes"
        views: "#{__dirname}/views"


    preConfigure: ->
        database = new SheppyDatabase
        database.connect()


exampleApp = new ExampleApp
exampleApp.init()
exampleApp.start()