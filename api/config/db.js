require('dotenv').config(); // Load environment variables from .env file
const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        console.log("Connecting to MongoDB...");
        await mongoose.connect(process.env.MONGO_URI, { // Use the environment variable
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log("MongoDB connected successfully.");
    } catch (error) {
        console.error("MongoDB connection error:", error);
    }
};

connectDB(); // Call the async function to initiate the connection
