const mongoose = require('mongoose');
const bcrypt = require("bcrypt");
const { Schema } = mongoose;

const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, "Email can't be empty"],
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "Email format is not correct",
        ],
        unique: true,
    },
    password: {
        type: String,
        required: [true, "Password is required"],
    },
    username: {
        type: String,
        required: [true, "Username can't be empty"],
        unique: true,
        trim: true,
        minlength: [3, "Username must be at least 3 characters long"],
        maxlength: [30, "Username cannot be more than 30 characters long"],
    },
    phone: {
        type: String,
        required: [true, "Phone number can't be empty"],
        unique: true,
        match: [/^\+?[1-9]\d{1,14}$/, "Phone number format is not correct"], // Adjust regex as needed for validation
    },
    likedArticles: [{ title: String, category: String }], // Field for liked articles
}, { timestamps: true });

// Hash password before saving
userSchema.pre("save", async function () {
    var user = this;
    if (!user.isModified("password")) {
        return;
    }
    try {
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(user.password, salt);
        user.password = hash;
    } catch (err) {
        throw err;
    }
});

// Compare password for sign-in
userSchema.methods.comparePassword = async function (candidatePassword) {
    try {
        const isMatch = await bcrypt.compare(candidatePassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
};

const UserModel = mongoose.model('user', userSchema);
module.exports = UserModel;
