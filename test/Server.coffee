chai = require "chai"
sinon = require "sinon"
sinonChai = require "sinon-chai"
should = chai.should()
chai.use sinonChai

http = require "http"

SheppyServer = require "../src/Server"

describe "SheppyCMS.Server", ->
    it "should be a constructor function", ->
        SheppyServer.should.be.a.function

    it "should have a customisable port", ->
        myServer = new SheppyServer(80)
        myServer.port.should.equal 80


    describe "create", ->
        it "should create a http server", ->
            myServer = new SheppyServer
            myServer.create()
            myServer.server.should.be.an.instanceof http.Server

    describe "start", ->
        it "should start the server and listen for connections", ->
            myServer = new SheppyServer
            myServer.create()
            sinon.stub myServer.server, "listen"
            myServer.start()
            myServer.server.listen.should.have.been.called

    describe "stop", ->
        it "should close the server connection", ->
            myServer = new SheppyServer
            myServer.create()
            sinon.stub myServer.server, "close"
            myServer.stop()
            myServer.server.close.should.have.been.called