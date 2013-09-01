mongoose = require "mongoose"
Component = require "./Component"


pageSchema = mongoose.Schema {
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
    "meta-description":
        type: String
        trim: true
    template:
        type: String
        trim: true
        "default": "page"
    components:
        [{ type: mongoose.Schema.Types.ObjectId, ref: "Component" }]
}

pageSchema.pre "save", (next) ->
    @modified = new Date
    next()


pageSchema.statics.findByUrl = (url, callback) ->
    return this.findOne({url: url})
        .select("template components title meta-description")
        .populate("components", "type region contents", null, {sort: "order"})
        .lean()
        .exec(callback)


# Create the model
module.exports = mongoose.model "Page", pageSchema