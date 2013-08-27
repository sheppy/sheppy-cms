mongoose = require "mongoose"
Log = require("../src/Log").SheppyCMS.Log


root = exports ? this

root.SheppyCMS ?= {}

class root.SheppyCMS.Database
    uri: "mongodb://localhost:27017/sheppy-cms"
    connected: false

    connect: ->
        mongoose.connection.on "connecting", () ->
            Log.info "MongoDB", "Connecting to database..."

        mongoose.connection.on "error", (error) ->
            if @connected then Log.error "MongoDB", "Error in database connection: #{error}"
            mongoose.disconnect()

        mongoose.connection.on "connected", () =>
            Log.success "MongoDB", "database connected!"
            @connected = true

        mongoose.connection.on "reconnected", () ->
            Log.success "MongoDB", "database reconnected!"

        mongoose.connection.on "disconnected", () ->
            if @connected then Log.warn "MongoDB", "database disconnected!"
            @connected = false
            mongoose.connect @uri, {server: {auto_reconnect: true}}

        mongoose.connect @uri, {server: {auto_reconnect: true}}