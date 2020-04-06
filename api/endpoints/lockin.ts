var express = require("express");
var router = express.Router();

var database = require("../database");

router.get("/lockin/:id", function(req: any, res: any) {
  var id = req.params.id;
  var query = `select * from lockins join lockin_text on lockins.id=lockin_text.id where lockins.id=${id}`;
  database.queryFetch(query, res);
});

router.post('/lockin/new', function(_req: any, _res: any) {
});

router.post('/lockin/edit', function(_req: any, _res: any) {
});

module.exports = router;