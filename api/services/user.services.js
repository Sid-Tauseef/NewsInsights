const UserModel = require("../models/user.model");
const jwt = require("jsonwebtoken");

class UserServices {
    
    static async registerUser(email, password, username, phone) {
        try {
            console.log("-----Email --- Password --- Username --- Phone-----", email, password, username, phone);
            
            const createUser = new UserModel({ email, password, username, phone }); // Added username and phone
            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }

    static async getUserByEmail(email) {
        try {
            return await UserModel.findOne({ email });
        } catch (err) {
            console.log(err);
        }
    }

    static async getUserByUsername(username) {  // New method to find user by username
        try {
            return await UserModel.findOne({ username });
        } catch (err) {
            console.log(err);
        }
    }

    static async getUserByPhone(phone) { // New method to find user by phone
        try {
            return await UserModel.findOne({ phone });
        } catch (err) {
            console.log(err);
        }
    }

    static async checkUser(email) {
        try {
            return await UserModel.findOne({ email });
        } catch (error) {
            throw error;
        }
    }

    static async generateAccessToken(tokenData, JWTSecret_Key, JWT_EXPIRE) {
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

module.exports = UserServices;
