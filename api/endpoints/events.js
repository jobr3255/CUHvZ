var express = require("express");
var router = express.Router();

var database = require("../database");

router.get("/weeklongs", function(req, res, next) {
  database.query('SELECT * from weeklongs ORDER BY id DESC', res);
});

router.get("/lockins", function(req, res, next) {
  database.query('SELECT * from lockins ORDER BY id DESC', res);
});

module.exports = router;
