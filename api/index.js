// const db = require('./config/db')
// const cors = require('cors');
// const express = require('express');
// const app = express();
// const port = 3000;


// // Enable CORS with specific options
// app.use(cors({
//     origin: '*', // Allow requests from any origin
// }));

// app.use(express.json()); // Parse JSON body
// app.use("/", require("./routes/user.router"));
// app.options('*', cors()); // Enable preflight requests for all routes

// app.listen(port, () => {
//     console.log(`Server listening on http://localhost:${port}`);
// });


const db = require('./config/db');
const cors = require('cors');
const express = require('express');
const app = express();
const port = 3000;

// Middleware for logging requests
app.use((req, res, next) => {
    console.log(`${req.method} request for '${req.url}'`, req.body);
    next();
});

// Enable CORS
app.use(cors({
    origin: 'http://localhost:3000', // Adjust this as needed
}));

app.use(express.json()); // Parse JSON body
app.use("/", require("./routes/user.router"));
app.options('*', cors()); // Enable preflight requests for all routes

app.listen(port, () => {
    console.log(`Server listening on http://localhost:${port}`);
});
