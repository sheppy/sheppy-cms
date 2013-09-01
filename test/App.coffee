chai = require "chai"
chaiAsPromised = require "chai-as-promised"
sinon = require "sinon"
sinonChai = require "sinon-chai"
should = chai.should()
chai.use chaiAsPromised
chai.use sinonChai

SheppyApp = require "../src/App"

describe "SheppyCMS.App", ->
    it "should be a constructor function", ->
        SheppyApp.should.be.a.function


    describe "init", ->
        myApp = null

        beforeEach ->
            myApp = new SheppyApp
            sinon.stub myApp, "createExpressApp"
            sinon.stub myApp, "configureApp"

        afterEach ->
            myApp.createExpressApp.restore
            myApp.configureApp.restore

        it "should create an express app", ->
            myApp.init()
            myApp.createExpressApp.should.have.been.called

        it "should configure the app", ->
            myApp.init()
            myApp.configureApp.should.have.been.called


    describe "configureApp", ->
        myApp = null

        beforeEach ->
            myApp = new SheppyApp
            myApp.createExpressApp()
            sinon.stub myApp, "configureGeneral"
            sinon.stub myApp, "configureProduction"
            sinon.stub myApp, "configureDevelopment"

        afterEach ->
            myApp.configureGeneral.restore
            myApp.configureProduction.restore
            myApp.configureDevelopment.restore

        it "should configure general settings in development mode", ->
            myApp.app.set "env", "development"
            myApp.configureApp()
            myApp.configureGeneral.should.have.been.called

        it "should configure development settings in development mode", ->
            myApp.app.set "env", "development"
            myApp.configureApp()
            myApp.configureDevelopment.should.have.been.called

        it "should not configure production settings in development mode", ->
            myApp.app.set "env", "development"
            myApp.configureApp()
            myApp.configureProduction.should.not.have.been.called

        it "should configure general settings in production mode", ->
            myApp.app.set "env", "production"
            myApp.configureApp()
            myApp.configureGeneral.should.have.been.called

        it "should configure production settings in production mode", ->
            myApp.app.set "env", "production"
            myApp.configureApp()
            myApp.configureProduction.should.have.been.called

        it "should not configure development settings in production mode", ->
            myApp.app.set "env", "production"
            myApp.configureApp()
            myApp.configureDevelopment.should.not.have.been.called


    describe "start", ->
        it "should start the server and listen for connections", (done) ->
            myApp = new SheppyApp
            myApp.createExpressApp()
            myApp.onStart = =>
                done()
                myApp.server.stop()
            myApp.start()


    describe "asd", ->