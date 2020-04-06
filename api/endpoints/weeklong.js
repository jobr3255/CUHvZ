var express = require("express");
var router = express.Router();

var database = require("../database");

router.get("/weeklong/:id", function(req, res, next) {
  var id = req.params.id;
  var query = `select * from weeklongs A join weeklong_details B on A.id=B.id where A.id=${id}`;
  database.queryFetch(query, res);
});

router.get("/weeklong/:id/players", function(req, res, next) {
  var id = req.params.id;
  var query = `select A.*,B.username,B.clearance from weeklong_players A join users B on A.user_id=B.id where A.weeklong_id=${id}`;
  database.queryFetchAll(query, res);
});

router.get("/weeklong/:id/details", function(req, res, next) {
  var id = req.params.id;
  var query = `select * from weeklongs A join weeklong_missions B on A.id=B.weeklong_id where A.id=${id}`;
  database.queryFetchAll(query, res);
});

router.get("/weeklong/:id/activity", function(req, res, next) {
  var id = req.params.id;
  var query = `select A.*,B.username as user1 ,C.username as user2 from activity A join users B on A.user1_id=B.id left join users C on A.user2_id=C.id where A.weeklong_id=${id}`;
  database.queryFetchAll(query, res);
});

router.get("/weeklong/:id/:playerid", function(req, res, next) {
  var id = req.params.id;
  var playerid = req.params.playerid;
  var query = `select A.*,B.username,B.clearance from weeklong_players A join users B on A.user_id=B.id where A.weeklong_id=${id} and B.id=${playerid}`;
  database.queryFetch(query, res);
});

router.post('/weeklong/new', function(req, res) {
});

router.post('/weeklong/edit', function(req, res) {
});

router.post('/weeklong/logkill', function(req, res) {
});

module.exports = router;
