mongoose = require "mongoose"
SheppyLog = require "./Log"


class SheppyDatabase
    uri: "mongodb://localhost:27017/sheppy-cms"
    connected: false

    connect: ->
        mongoose.connection.on "connecting", () ->
            SheppyLog.info "MongoDB", "Connecting to database..."

        mongoose.connection.on "error", (error) ->
            if @connected then SheppyLog.error "MongoDB", "Error in database connection: #{error}"
            mongoose.disconnect()

        mongoose.connection.on "connected", () =>
            SheppyLog.success "MongoDB", "database connected!"
            @connected = true

        mongoose.connection.on "reconnected", () ->
            SheppyLog.success "MongoDB", "database reconnected!"

        mongoose.connection.on "disconnected", () ->
            if @connected then SheppyLog.warn "MongoDB", "database disconnected!"
            @connected = false
            mongoose.connect @uri, {server: {auto_reconnect: true}}

        mongoose.connect @uri, {server: {auto_reconnect: true}}


module.exports = SheppyDatabase