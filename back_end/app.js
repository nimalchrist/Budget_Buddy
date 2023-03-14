// all the modules
const express = require("express");
const router = require("./routes/index");

// express instance and port number
const app = express();
const port = 3000;

// middlewares
app.use(express.json());
app.use(
  express.urlencoded({
    extended: true,
  })
);

//using routes
app.use("/", router);

// server start method
app.listen(port, function () {
  console.log("Server started and running at port 3000");
});
