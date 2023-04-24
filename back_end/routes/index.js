const express = require("express");
const router = express.Router();
const controllers = require("../controllers/index");

// Routes

// default route
router.route("/").get(function (req, res) {
  res.send("Hello world");
});

// testing route
router.route("/users").get(controllers.getAllUsers);

// to get categories
router.route("/categories").get(controllers.fetchCategories);

// to get daily transactions
router.route("/:user_id/:date").get(controllers.getDailyTransactions);

// to get monthly total
router
  .route("/monthlytotal/:user_id")
  .post(controllers.getTotalTransactionOfMonth);

// to get monthly balance
router.route("/balance/:user_id").post(controllers.getMonthlyBalanceAmount);

// to add an expense
router.route("/:user_id/addExpense").post(controllers.addExpenseDaily);

// to fetch for graph data
router.route("/fetchGraphData/:user_id").post(controllers.fetchGraphData);

// to check wether the budget is setted or not
router.route("/budgets/:user_id/:month/:year").get(controllers.isBudgetSetted);

// manipulation of expenses
router.route("/editExpense/:expense_id").post(controllers.editExpense);
router.route("/deleteExpense/:expense_id").post(controllers.deleteExpense);
router.route("/budget/:user_id").post(controllers.getBudgetAmount);
router.route("/profileInfo/:user_id").post(controllers.getProfileInfo);

// login and register
router.route("/login").post(controllers.loginUser);
router.route("/register").post(controllers.registerUser);

module.exports = router;
