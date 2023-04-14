const conn = require("../services/db");

exports.getAllUsers = (req, res, next) => {
  conn.query("SELECT * FROM users", function (err, data, fields) {
    if (err) return err;
    res.status(200).json(data);
  });
};

exports.getDailyTransactions = (req, res) => {
  let userId = req.params.user_id;
  let date = req.params.date;
  let values = [date, userId];

  let queryString =
    "SELECT e.expense_id, e.user_id, c.category_name, e.amount, e.expense_date FROM expenses e JOIN categories c ON e.category_id = c.category_id WHERE e.expense_date = ? and user_id = ? ORDER BY e.user_id";

  conn.query(queryString, values, function (err, data) {
    if (err) {
      return res.status(500).json(err);
    }
    if (data.length == 0) {
      return res.status(200).json([{ message: "No data found" }]);
    }
    return res.status(200).json(data);
  });
};

exports.getTotalTransactionOfMonth = (req, res) => {
  let userId = req.params.user_id;
  let month = req.body.current_month;
  let year = req.body.current_year;
  values = [userId, month, year, userId, month, year];
  const queryString = `
    SELECT
      (SELECT SUM(amount) FROM budgets WHERE user_id = ? AND MONTH(income_date) = ? AND YEAR(income_date) = ?) AS total_income,
      (SELECT SUM(amount) FROM expenses WHERE user_id = ? AND MONTH(expense_date) = ? AND YEAR(expense_date) = ?) AS total_expenses;
  `;
  conn.query(queryString, values, function (err, results) {
    if (err) {
      return res
        .status(500)
        .json({ error: "Error fetching totals from database" });
    } else {
      // Extract total_income and total_expenses from query results
      const { total_income, total_expenses } = results[0];
      return res.json([{ total_income, total_expenses }]);
    }
  });
};

exports.getMonthlyBalanceAmount = (req, res) => {
  let userId = req.params.user_id;
  let month = req.body.current_month;
  let year = req.body.current_year;

  values = [userId, month, year];
  const queryString = `SELECT balance FROM balances WHERE user_id = ? AND month = ? AND year = ?`;

  conn.query(queryString, values, function (err, results) {
    if (err) {
      return res
        .status(500)
        .json({ error: "Error fetching totals from database" });
    } else if (results.length == 0) {
      res.status(404).json([{ msg: "No balance" }]);
    } else {
      const balance = results[0].balance;
      res.json([{ balance: balance }]);
    }
  });
};

exports.addExpenseDaily = (req, res) => {
  let userId = req.params.user_id;
  let categoryId = req.body.category_id;
  let expenseAmount = req.body.amount;
  let expenseDate = req.body.date;
  dateChecker = new Date(expenseDate);

  // First, check if the user has set their budget for the current month
  const budgetQuery = `SELECT amount FROM budgets WHERE user_id = ? AND MONTH(income_date) = ? AND YEAR(income_date) = ?`;
  const budgetValues = [
    userId,
    dateChecker.getMonth() + 1,
    dateChecker.getFullYear(),
  ];
  conn.query(budgetQuery, budgetValues, function (budgetErr, budgetResults) {
    if (budgetErr) {
      return res.status(500).json([{ msg: "Server error" }]);
    }
    if (budgetResults.length === 0) {
      // The user hasn't set their budget for the current month, so return an error
      return res.status(400).json([{ msg: "No budget is set for this month" }]);
    }

    // If the user has set their budget, add the expense
    const values = [userId, categoryId, expenseAmount, expenseDate];
    const queryString = `INSERT INTO expenses(user_id, category_id, amount, expense_date) VALUES(?, ?, ?, ?)`;

    conn.query(queryString, values, function (err, results) {
      if (err) {
        console.log(err);
        return res.status(500).json([{ msg: "Insert Server error" }]);
      } else {
        return res.status(200).json([{ msg: "Added successfully" }]);
      }
    });
  });
};

exports.fetchCategories = (req, res) => {
  conn.query("SELECT * FROM categories", function (err, data, fields) {
    if (err) return err;
    res.status(200).json(data);
  });
};

exports.fetchGraphData = (req, res) => {
  let userId = req.params.user_id;

  const queryString = `SELECT DAY(expense_date) as day, SUM(amount) as daily_total FROM expenses WHERE user_id = ? AND MONTH(expense_date) = MONTH(CURDATE()) AND YEAR(expense_date) = YEAR(CURDATE()) GROUP BY user_id, expense_date ORDER BY day ASC`;

  values = [userId];

  conn.query(queryString, values, function (err, data, fields) {
    if (err) {
      res.status(500).json(err);
    } else {
      res.status(200).json(data);
    }
  });
};
