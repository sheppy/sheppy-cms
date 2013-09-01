mongoose = require "mongoose"
bcrypt = require "bcrypt"
SALT_WORK_FACTOR = 10


userSchema = mongoose.Schema {
    updated:
        type: Date
        "default": Date.now
    name:
        type: String
        required: true
        trim: true
    email:
        type: String
        required: true
        trim: true
        index:
            unique: true
    password:
        type: String
        required: true
}


userSchema.pre "save", (next) ->
    # Only hash the password if it has been modified (or is new)
    if !@isModified "password"
        return next()
    
    # Generate a salt
    bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) =>
        # Hash the password along with our new salt
        bcrypt.hash @password, salt, (err, hash) =>
            if err then return next err
            
            # Override the cleartext password with the hashed one
            @password = hash
            next()


userSchema.methods.comparePassword = (candidatePassword, callback) ->
    bcrypt.compare candidatePassword, @password, (err, isMatch) ->
        if err then return callback err
        callback null, isMatch


# Create the model
module.exports = mongoose.model "User", userSchema