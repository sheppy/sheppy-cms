# Usage:
# express = require "express"
# require("./MultiViews")(express)
 
module.exports = (app) ->
    # Monkey-patch express to accept multiple paths for looking up views.
    # this path may change depending on your setup.
    lookup_proxy = app.get("view").prototype.lookup;

    app.get("view").prototype.lookup = (viewName) ->
        context = null
        match = null
        if this.root instanceof Array
            for i in [0...@root.length]
                context = {root: @root[i]}
                match = lookup_proxy.call(context, viewName)
                if match then return match
            return null
        return lookup_proxy.call(this, viewName)


###
module.exports = (express) ->
    old = express.view.lookup
    
    console.log("here");
    console.log(old);
 
    lookup = (view, options) ->
        # If root is an array of paths, let's try each path until we find the view
        if options.root instanceof Array
            opts = {}
            foundView = null
            
            opts[key] = options[key] for key in options
            root = opts.root
            for i in [0...root.length]
                opts.root = root[i]
                foundView = old.call(this, view, opts)
                if foundView.exists then break

            return foundView
 
        # Fallback to standard behavior, when root is a single directory
        return old.call(express.view, view, options)
 
    express.view.lookup = lookup;

###