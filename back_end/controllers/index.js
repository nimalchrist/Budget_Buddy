const conn = require("../services/db");

exports.getAllUsers = (req, res, next) => {
  conn.query("SELECT * FROM users", function (err, data, fields) {
    if (err) return err;
    res.status(200).json({
      status: "success",
      length: data?.length,
      data: data,
    });
  });
};
