const mysql = require("mysql2");
require("dotenv").config();

const connection = mysql.createConnection({
  host: "budget-buddy-db.caxjmojddnbu.us-east-1.rds.amazonaws.com",
  user: "admin",
  password: "ninunimal",
  database: "budget_buddy_db",
  waitForConnections: true,
  timezone: "utc",
});

connection.connect(function (err) {
  if (err) {
    throw err;
  }
  console.log("Connected successfully");
});

module.exports = connection;
