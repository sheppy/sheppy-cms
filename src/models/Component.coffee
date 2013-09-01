mongoose = require "mongoose"


componentSchema = mongoose.Schema {
    created:
        type: Date
        "default": Date.now
    modified:
        type: Date
        "default": Date.now
    type:
        type: String
        required: true
        trim: true
    region:
        type: String
        required: true
        trim: true
    order:
        type: Number
    contents: {}
}

componentSchema.pre "save", (next) ->
    @modified = new Date
    next()

# Create the model
module.exports = mongoose.model "Component", componentSchema