var express = require("express");
var router = express.Router();

router.get("/lockin/:id", function(req, res, next) {
  var id = req.params.id;
  var query = `select * from lockins join lockin_text on lockins.id=lockin_text.id where lockins.id=${id}`;
  database.queryFetch(query, res);
});

router.post('/lockin/new', function(req, res) {
});

router.post('/lockin/edit', function(req, res) {
});

module.exports = router;
