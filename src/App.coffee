fs = require "fs"
express = require "express"
http = require "http"
compression = require "compression"
bodyParser = require "body-parser"
methodOverride = require "method-override"
responseTime = require "response-time"
cookieParser = require "cookie-parser"
helmet = require "helmet"
assets = require "connect-assets"

SheppyServer = require "./Server"
SheppyLog = require "./Log"
SheppyCMS = require "./CMS"
MultiViews = require "./MultiViews"


class SheppyApp
    app: null
    server: null
    defaultPort: 3000
    secretKey: "secretkey"
    paths:
        docroot: "#{__dirname}/../public"
        assets: "#{__dirname}/../public/assets"
        routes: "#{__dirname}/routes"
        views: "#{__dirname}/views"


    init: ->
        @createExpressApp()
        @configureApp()


    createExpressApp: ->
        @app = express()


    configureApp: ->
        @preConfigure()

        if @app.settings.env == "development"
            @configureDevelopment()
        else
            @configureProduction()

        @postConfigure()


    preConfigure: ->


    postConfigure: ->
        @app.set "port", process.env.PORT || @defaultPort
        @app.set "view engine", "jade"
        MultiViews @app # Enable multiple view directories
        @app.set "views", [@paths.views, "#{__dirname}/views"]
        
        @app.use compression() # Enable gzip
        @app.use bodyParser.urlencoded({extended: true})
        @app.use bodyParser.json()
        @app.use helmet.xframe()
        @app.use helmet.xssFilter()
        @app.use helmet.nosniff()
        @app.use helmet.hidePoweredBy()
        @app.use helmet.crossdomain()
        #@app.use helmet.nocache()
        @app.use methodOverride()
        @app.use responseTime()
        @app.use cookieParser @secretKey
        
        ###
        # Only initialise sessions on admin routes
        @app.use (req, res, next) ->
            if req.url.indexOf("/admin") == -1 then return next()
            sessionMiddleware = session {
                store: new MongoStore({
                    mongoose_connection: mongoose.connection
                })
                key: "sid"
                secret: "secretkey"
            }
            sessionMiddleware(req, res, next)
    
        @initPassport()
        ###
        
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


    configureDevelopment: ->

    configureProduction: ->

    onStart: ->
        SheppyLog.success "Express", "server listening on port " + @app.get("port")

    start: ->
        @server = new SheppyServer @app.get("port")
        @server.create @app
        @server.start => @onStart()


    # Automatically include all of our routes
    loadRoutes: ->
        fs.readdirSync(@paths.routes).forEach (filename) =>
            @app.use require "#{@paths.routes}/#{filename}"
            SheppyLog.success "Route", "\t✔ #{filename}"


    addCmsRoute: ->
        SheppyCMS.initRoute @app


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


module.exports = SheppyApp