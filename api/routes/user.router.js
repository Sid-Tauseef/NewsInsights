const router = require("express").Router();
const UserController = require('../controller/user.controller');

router.post("/registration",UserController.register);

router.post("/login", UserController.login);

router.post("/likeArticle", UserController.likeArticle);

router.post("/getRecommendations", UserController.getRecommendations);

router.post("/getUserDetails", UserController.getUserDetails); // Add this line

module.exports = router;
