mongoose = require "mongoose"
SheppyLog = require "./Log"

# https://gist.github.com/prabirshrestha/6539888

class SheppyDatabase
    uri: null
    sleep: 1000
    timer: null

    constructor: (@uri = "mongodb://localhost:27017/sheppy-cms") ->


    connect: ->
        _connect = =>
            mongoose.connect @uri, {server: {auto_reconnect: true}}

        mongoose.connection.on "connecting", ->
            SheppyLog.info "MongoDB", "Connecting to database..."

        mongoose.connection.on "error", (error) ->
            SheppyLog.error "MongoDB", "Error in database connection: #{error}"
            mongoose.disconnect()

        mongoose.connection.on "connected", ->
            SheppyLog.success "MongoDB", "database connected!"

        mongoose.connection.on "open", =>
            clearTimeout @timer
            
        mongoose.connection.on "reconnected", ->
            SheppyLog.success "MongoDB", "database reconnected!"

        mongoose.connection.on "disconnected", =>
            SheppyLog.warn "MongoDB", "database disconnected!"
            @timer = setTimeout _connect, @sleep

        _connect()


module.exports = SheppyDatabase