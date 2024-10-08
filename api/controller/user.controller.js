// const UserServices = require('../services/user.services');

// exports.register = async (req, res, next) => {
//     try {
//         console.log("---req body---", req.body);
//         const { email, password, username, phone } = req.body;  // Added username and phone
//         const duplicateEmail = await UserServices.getUserByEmail(email);
//         const duplicateUsername = await UserServices.getUserByUsername(username);  // Check for duplicate username
//         const duplicatePhone = await UserServices.getUserByPhone(phone);  // Check for duplicate phone number

//         if (duplicateEmail) {
//             throw new Error(`Email ${email} is already registered.`);
//         }

//         if (duplicateUsername) {
//             throw new Error(`Username ${username} is already taken.`);
//         }

//         if (duplicatePhone) {
//             throw new Error(`Phone number ${phone} is already registered.`);
//         }

//         const response = await UserServices.registerUser(email, password, username, phone); // Pass all required fields

//         res.json({ status: true, success: 'User registered successfully' });

//     } catch (err) {
//         console.log("---> err -->", err);
//         next(err);
//     }
// }

// exports.login = async (req, res, next) => {
//     try {
//         const { email, password } = req.body;

//         if (!email || !password) {
//             throw new Error('Parameters are not correct');
//         }

//         let user = await UserServices.checkUser(email);
//         if (!user) {
//             throw new Error('User does not exist');
//         }

//         const isPasswordCorrect = await user.comparePassword(password);

//         if (isPasswordCorrect === false) {
//             throw new Error(`Username or Password does not match`);
//         }

//         // Creating Token
//         let tokenData;
//         tokenData = { _id: user._id, email: user.email };

//         const token = await UserServices.generateAccessToken(tokenData, "secret", "1h");

//         res.status(200).json({ status: true, success: "sendData", token: token });
//     } catch (error) {
//         console.log(error, 'err---->');
//         next(error);
//     }
// }


const UserServices = require('../services/user.services');

exports.register = async (req, res, next) => {
    try {
        console.log("---req body---", req.body);
        const { email, password, username, phone } = req.body;

        const duplicateEmail = await UserServices.getUserByEmail(email);
        const duplicateUsername = await UserServices.getUserByUsername(username);
        const duplicatePhone = await UserServices.getUserByPhone(phone);

        if (duplicateEmail) {
            return res.status(400).json({ status: false, message: `Email ${email} is already registered.` });
        }

        if (duplicateUsername) {
            return res.status(400).json({ status: false, message: `Username ${username} is already taken.` });
        }

        if (duplicatePhone) {
            return res.status(400).json({ status: false, message: `Phone number ${phone} is already registered.` });
        }

        await UserServices.registerUser(email, password, username, phone);
        res.status(201).json({ status: true, message: 'User registered successfully' });

    } catch (err) {
        console.error("---> err -->", err);
        res.status(500).json({ status: false, message: 'Internal server error' });
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ status: false, message: 'Parameters are not correct' });
        }

        let user = await UserServices.checkUser(email);
        if (!user) {
            return res.status(404).json({ status: false, message: 'User does not exist' });
        }

        const isPasswordCorrect = await user.comparePassword(password);
        if (!isPasswordCorrect) {
            return res.status(401).json({ status: false, message: 'Username or Password does not match' });
        }

        const tokenData = { _id: user._id, email: user.email };
        const token = await UserServices.generateAccessToken(tokenData, "secret", "1h");

        res.status(200).json({ status: true, message: "Login successful", token: token });
    } catch (error) {
        console.error(error, 'err---->');
        res.status(500).json({ status: false, message: 'Internal server error' });
    }
}



exports.likeArticle = async (req, res, next) => {
    try {
        const { email, articleTitle, articleCategory } = req.body;
        const user = await UserServices.getUserByEmail(email);

        if (!user) {
            throw new Error('User not found');
        }

        // Update the user's liked articles
        user.likedArticles.push({ title: articleTitle, category: articleCategory });
        await user.save();

        res.status(200).json({ status: true, message: 'Article liked' });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
};

exports.getRecommendations = async (req, res, next) => {
    try {
        const { email } = req.body;
        const user = await UserServices.getUserByEmail(email);

        if (!user) {
            throw new Error('User not found');
        }

        const likedCategories = user.likedArticles.map(article => article.category);

        // Fetch recommended articles based on liked categories
        const recommendations = await NewsAPIService.getRecommendations(likedCategories);

        res.status(200).json({ status: true, data: recommendations });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
};


exports.getUserDetails = async (req, res, next) => {
    try {
        const { email } = req.body;  // You can use token data instead of email for better security
        const user = await UserServices.getUserByEmail(email);

        if (!user) {
            throw new Error('User not found');
        }

        // Exclude sensitive information
        const { password, ...userDetails } = user._doc; // use _doc to convert mongoose document to plain object
        res.status(200).json({ status: true, data: userDetails });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
};
