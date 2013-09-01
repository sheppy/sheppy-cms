http = require "http"


class SheppyServer
    server: null
    port: null

    constructor: (@port) ->

    create: (app = null) -> @server = http.createServer app

    start: (callback) -> @server.listen @port, callback

    stop: (callback) -> @server.close callback


module.exports = SheppyServer