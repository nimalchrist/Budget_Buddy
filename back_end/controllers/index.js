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
        return res.status(500).json([{ msg: "Server error" }]);
      } else {
        return res.status(200).json([{ msg: "Added successfully" }]);
      }
    });
  });
};

exports.editExpense = (req, res) => {
  const expenseId = req.params.expense_id;
  const expenseAmount = req.body.amount;

  if (!expenseId || !expenseAmount || isNaN(expenseAmount)) {
    res.status(400).json({ msg: "Invalid request" });
    return;
  }

  const queryString = "UPDATE expenses SET amount = ? WHERE expense_id = ?;";
  const values = [expenseAmount, expenseId];

  conn.query(queryString, values, function (err, data) {
    if (err) {
      res.status(500).json(err);
      return;
    }

    // Check that at least one row was updated
    if (data.affectedRows === 0) {
      res.status(404).json({ msg: "Expense not found" });
      return;
    }

    res.status(200).json({ msg: "Updated successfully" });
  });
};

exports.deleteExpense = (req, res) => {
  const expenseId = req.params.expense_id;

  if (!expenseId) {
    res.status(400).json({ msg: "Invalid request" });
    return;
  }

  const queryString = "DELETE from expenses where expense_id = ?";
  values = [expenseId];

  conn.query(queryString, values, function (err, data) {
    if (err) {
      res.status(500).json({ msg: "Unexpected error happened" });
      return;
    }

    if (data.affectedRows === 0) {
      res.status(404).json({ msg: "Expense not found" });
      return;
    }
    res.status(200).json({ msg: "Deleted successfully" });
  });
};

exports.addBudget = (req, res) => {
  let userId = req.params.user_id;
  let amount = req.body.budget_amount;
  let income_date = req.body.budget_setting_date;
  dateChecker = new Date(income_date);

  const checkQuery =
    "select amount from budgets where user_id = ? and month(income_date) = ? and year(income_date) = ?";
  const budgetValues = [
    userId,
    dateChecker.getMonth() + 1,
    dateChecker.getFullYear(),
  ];

  conn.query(checkQuery, budgetValues, function (budgetErr, budgetResults) {
    if (budgetErr) {
      return res.status(500).json([{ msg: "Server Error" }]);
    }
    if (budgetResults.length != 0) {
      return res
        .status(400)
        .json([{ msg: "Already budget is set for this month" }]);
    } else {
      const queryString =
        "Insert into budgets(user_id, amount, income_date) values(?,?,?)";
      const values = [userId, amount, income_date];

      conn.query(queryString, values, function (err, results) {
        if (err) {
          return res.status(500).json([{ msg: "Error with server" }]);
        }
        return res.status(200).json([{ msg: "Added successfully" }]);
      });
    }
  });
};

exports.isBudgetSetted = (req, res) => {
  const userId = req.params.user_id;
  const month = req.params.month;
  const year = req.params.year;

  const queryString = `SELECT amount FROM budgets WHERE user_id = ? AND MONTH(income_date) = ? AND YEAR(income_date) = ?;`;

  const values = [userId, month, year];
  conn.query(queryString, values, function (err, data) {
    if (err) {
      res.status(500).json(err);
    }
    if (data.length == 0) {
      res.status(200).json({ isSet: false });
    } else {
      res.status(200).json({ isSet: true });
    }
  });
};

exports.getBudgetAmount = (req, res) => {
  let userId = req.params.user_id;
  let month = req.body.current_month;
  let year = req.body.current_year;
  let values = [userId, month, year];
  const queryString =
    "SELECT amount as budget FROM budgets WHERE user_id = ? AND MONTH(income_date) = ? AND YEAR(income_date) = ?";
  conn.query(queryString, values, function (err, results) {
    if (err) {
      return res.status(500).json({ error: "Error fetching from database" });
    } else {
      const budget = results[0];
      if (budget == null) {
        return res.status(200).json({ budget: null });
      }
      return res.status(200).json(budget);
    }
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

exports.getProfileInfo = (req, res) => {
  let userId = req.params.user_id;

  let queryString = `select user_name, email, registered_at from users where user_id = ?`;
  conn.query(queryString, userId, function (err, results) {
    if (err) {
      return res.status(500).json({ error: "Error fetching from database" });
    } else {
      if (results.length == 0) {
        return res.status(200).json({ msg: "No user found" });
      }
      return res.status(200).json(results);
    }
  });
};

exports.getListOfMonthlyBudgets = (req, res) => {
  let userId = req.params.user_id;

  let queryString = "select amount, income_date from budgets where user_id = ?";

  conn.query(queryString, userId, function (err, results) {
    if (err) {
      return res.status(500).json({ error: "Error fetching from database" });
    }
    return res.status(200).json(results);
  });
};

exports.getListOfMonthlyExpenses = (req, res) => {
  let userId = req.params.user_id;

  let queryString = `SELECT MONTH(expense_date) AS month, SUM(amount) AS total_expenses FROM expenses WHERE user_id = ? GROUP BY MONTH(expense_date) ORDER BY MONTH(expense_date) ASC`;

  conn.query(queryString, userId, function (err, results) {
    if (err) {
      return res.status(500).json({ error: "Error fetching from database" });
    }
    return res.status(200).json(results);
  });
};

exports.loginUser = (req, res) => {
  const { email, password } = req.body;
  selectString = "select email, password from users where email = ?";
  conn.query(selectString, email, function (err, results) {
    if (err) {
      return res.status(500).json({ msg: "Error with the server" });
    }
    if (results.length == 0) {
      return res.status(404).json({ msg: "Invalid Login Credentials" });
    } else {
      let checkPass = results[0].password;
      let confirmationString = "Select user_id from users where email = ?";
      if (password == checkPass) {
        conn.query(confirmationString, email, function (error, result) {
          if (err) {
            return res.status(500).json({ msg: "Error with the server" });
          }
          res.status(200).json({
            msg: "Login successfull",
            user_id: result[0].user_id,
          });
        });
      } else {
        res.status(404).json({ msg: "Sorry wrong password" });
      }
    }
  });
};

exports.registerUser = (req, res) => {
  const { username, email, password } = req.body;
  values = [username, email, password];

  const selectString = "Select email from users where email = ?";
  conn.query(selectString, email, function (err, results) {
    if (err) {
      return res.status(500).json({ msg: "Error with the server" });
    }
    if (results.length != 0) {
      return res
        .status(404)
        .json({ msg: "Email Already Exist, Enter a new Email" });
    } else {
      const insertString =
        "Insert into users(user_name, email, password) values(?)";
      conn.query(insertString, [values], function (err, results) {
        if (err) {
          return res.status(500).json({ msg: "Error with the server" });
        }
        const idQueryString = "Select user_id from users where email = ?";
        conn.query(idQueryString, email, function (err, results) {
          if (err) {
            return res.status(500).json({ msg: "Error with the server" });
          }
          return res.status(200).json({
            msg: "Registered successfully",
            user_id: results[0].user_id,
          });
        });
      });
    }
  });
};
