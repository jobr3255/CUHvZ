var express = require("express");
var router = express.Router();

import Database from "../Database";

router.get("/weeklongs", function(_req: any, res: any) {
  let db: Database = Database.getInstance();
  db.queryFetchAll('SELECT * from weeklongs ORDER BY id DESC', res);
});

router.get("/lockins", function(_req: any, res: any) {
  let db: Database = Database.getInstance();
  db.queryFetchAll('SELECT * from lockins ORDER BY id DESC', res);
});

module.exports = router;
