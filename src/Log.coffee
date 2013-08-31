colors = require "colors"
moment = require "moment"


class SheppyLog
    @log: (message) ->
        console.log "[#{moment().format("YYYY-MM-DD HH:mm:ss.SSS")}] ".italic + message

    @noise: (title, message) ->
        message = "#{title} :: ".bold + message
        SheppyLog.log "#{message}".grey

    @info: (title, message) ->
        message = "#{title} :: ".bold + message
        SheppyLog.log "#{message}".cyan

    @success: (title, message) ->
        message = "#{title} :: ".bold + message
        SheppyLog.log "#{message}".green

    @warn: (title, message) ->
        message = "#{title} :: ".bold + message
        SheppyLog.log "#{message}".yellow

    @error: (title, message) ->
        message = "#{title} :: ".bold + message
        SheppyLog.log "#{message}".red


module.exports = SheppyLog