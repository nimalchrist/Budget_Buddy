const express = require("express");
const router = express.Router();
const controllers = require("../controllers/index");

router.route("/").get(function (req, res) {
  res.send("Hello world");
});
router.route("/users").get(controllers.getAllUsers);
// Define routes for the root URL and /users URL

module.exports = router;
