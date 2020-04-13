var express = require("express");
var router = express.Router();

import Database from "../Database";

router.get("/weeklong/:id", function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var id = req.params.id;
  var query = `select * from weeklongs A join weeklong_details B on A.id=B.id where A.id=${id}`;
  db.queryFetch(query, res);
});

router.get("/weeklong/:id/players", function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var id = req.params.id;
  var query = `select A.*,B.username,B.clearance,C.end_date from weeklong_players A join users B on A.user_id=B.id join weeklongs C on A.weeklong_id=C.id where A.weeklong_id=${id}`;
  db.queryFetchAll(query, res);
});

router.get("/weeklong/:id/missions", function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var id = req.params.id;
  var query = `select B.* from weeklongs A join weeklong_missions B on A.id=B.weeklong_id where A.id=${id}`;
  db.queryFetchAll(query, res);
});

router.get("/weeklong/:id/activity", function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var id = req.params.id;
  var query = `select A.*,B.username as user1 ,C.username as user2 from activity A join users B on A.user1_id=B.id left join users C on A.user2_id=C.id where A.weeklong_id=${id}`;
  db.queryFetchAll(query, res);
});

router.get("/weeklong/:id/:playerid", function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var id = req.params.id;
  var playerid = req.params.playerid;
  var query = `select A.*,B.username,B.clearance from weeklong_players A join users B on A.user_id=B.id where A.weeklong_id=${id} and B.id=${playerid}`;
  db.queryFetch(query, res);
});

router.post('/weeklong/new', function(_req: any, _res: any) {
});

router.post('/weeklong/edit', function(_req: any, _res: any) {
});

router.post('/weeklong/logkill', function(_req: any, _res: any) {
});

module.exports = router;
