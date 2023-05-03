const mysql = require("mysql2");
require("dotenv").config();

const connection = mysql.createConnection({
  host: "budget-buddy-db.caxjmojddnbu.us-east-1.rds.amazonaws.com",
  user: "admin",
  password: "Ninunimal",
  database: "budget-buddy-db",
  waitForConnections: true,
  connectTimeout: 20000,
});

connection.connect(function (err) {
  if (err) {
    throw err;
  }
  console.log("Connected successfully");
});

module.exports = connection;
