mongoose = require "mongoose"
Component = require "./Component"
Comment = require "./Comment"


postSchema = mongoose.Schema {
    created:
        type: Date
        "default": Date.now
    modified:
        type: Date
        "default": Date.now
    url:
        type: String
        trim: true
        lowercase: true
        unique: true
        required: true
    title:
        type: String
        trim: true
        required: true
#    author: { type: mongoose.Schema.Types.ObjectId, ref: "User" }
    state:
        type: String
        "enum": ["draft", "published"]
        required: true
        "default": "draft"
    body:
        type: String
        trim: true
        required: true
    components:
        [{ type: mongoose.Schema.Types.ObjectId, ref: "Component" }]
    comments:
        [{ type: mongoose.Schema.Types.ObjectId, ref: "Comment" }]
}

postSchema.pre "save", (next) ->
    @modified = new Date
    next()

# Create the model
module.exports = mongoose.model "Post", postSchema