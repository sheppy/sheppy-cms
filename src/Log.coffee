chalk = require "chalk"
moment = require "moment"


class SheppyLog
    @log: (message) ->
        console.log chalk.gray("[" + moment().format("YYYY-MM-DD HH:mm:ss.SSS") + "]") + " " + message

    @noise: (title, message) ->
        message = chalk.bold("#{title} :: ") + message
        SheppyLog.log chalk.gray("#{message}")

    @info: (title, message) ->
        message = chalk.bold("#{title} :: ") + message
        SheppyLog.log chalk.cyan("#{message}")

    @success: (title, message) ->
        message = chalk.bold("#{title} :: ") + message
        SheppyLog.log chalk.green("#{message}")

    @warn: (title, message) ->
        message = chalk.bold("#{title} :: ") + message
        SheppyLog.log chalk.yellow("#{message}")

    @error: (title, message) ->
        message = chalk.bold("#{title} :: ") + message
        SheppyLog.log chalk.red("#{message}")


module.exports = SheppyLog