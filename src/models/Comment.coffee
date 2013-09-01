mongoose = require "mongoose"


commentSchema = mongoose.Schema {
    created:
        type: Date
        "default": Date.now
    name:
        type: String
        trim: true
        required: true
    body:
        type: String
        trim: true
        required: true
}


# Create the model
module.exports = mongoose.model "Comment", commentSchema