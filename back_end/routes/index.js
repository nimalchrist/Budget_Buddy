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

// to get list of monthly budgets
router
  .route("/:user_id/listOfBudgets")
  .post(controllers.getListOfMonthlyBudgets);

// to get list of m0nthly expenses
router
  .route("/:user_id/listOfExpenses")
  .post(controllers.getListOfMonthlyExpenses);

// to add an expense
router.route("/:user_id/addExpense").post(controllers.addExpenseDaily);

// to fetch for graph data
router.route("/fetchGraphData/:user_id").post(controllers.fetchGraphData);

// manipulation of expenses
router.route("/editExpense/:expense_id").post(controllers.editExpense);
router.route("/deleteExpense/:expense_id").post(controllers.deleteExpense);

// get budget amount
router.route("/budget/:user_id").post(controllers.getBudgetAmount);

// to check wether the budget is setted or not
router.route("/budgets/:user_id/:month/:year").get(controllers.isBudgetSetted);

// to add a budget
router.route("/:user_id/addBudget").post(controllers.addBudget);

// get our profile info
router.route("/profileInfo/:user_id").post(controllers.getProfileInfo);

// login and register
router.route("/login").post(controllers.loginUser);
router.route("/register").post(controllers.registerUser);

module.exports = router;
