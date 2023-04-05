const express = require("express");
const router = express.Router();
const controllers = require("../controllers/index");

router.route("/").get(function (req, res) {
  res.send("Hello world");
});
router.route("/users").get(controllers.getAllUsers);

router.route("/:user_id/:date").get(controllers.getDailyTransactions);

router
  .route("/monthlytotal/:user_id")
  .post(controllers.getTotalTransactionOfMonth);

router.route("/balance/:user_id").post(controllers.getMonthlyBalanceAmount);
// Define routes for the root URL and /users URL

module.exports = router;
