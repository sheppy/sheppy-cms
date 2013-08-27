colors = require "colors"
moment = require "moment"


root = exports ? this

root.SheppyCMS ?= {}

class root.SheppyCMS.Log
    @log: (message) ->
        console.log "[#{moment().format("YYYY-MM-DD HH:mm:ss.SSS")}] ".italic + message

    @noise: (title, message) ->
        message = "#{title} :: ".bold + message
        Log.log "#{message}".grey

    @info: (title, message) ->
        message = "#{title} :: ".bold + message
        Log.log "#{message}".cyan

    @success: (title, message) ->
        message = "#{title} :: ".bold + message
        Log.log "#{message}".green

    @warn: (title, message) ->
        message = "#{title} :: ".bold + message
        Log.log "#{message}".yellow

    @error: (title, message) ->
        message = "#{title} :: ".bold + message
        Log.log "#{message}".red