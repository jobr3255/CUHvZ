var express = require("express");
var router = express.Router();
var Password = require("node-php-password");

import Database from "../Database";
// var Password = require("../Password");

router.get("/users", function(_req: any, res: any) {
  let db: Database = Database.getInstance();
  db.queryFetchAll('SELECT username,email from users', res);
});

router.post('/user/new', function(_req: any, _res: any) {
});

router.post('/user/edit', function(_req: any, _res: any) {
});

router.post('/user/login', function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var user = req.body.user;
  var pass = req.body.password;
  db.queryFetch(`select * from users where (username="${user}" OR email="${user}")`, null, (data: any) => {
    if (!data) {
      // Not found
      res.status(404).send();
    } else if (data["error"]) {
      res.status(400).send(data["error"]);
    } else {
      var passHash = data["password"];
      if (Password.verify(pass, passHash)) {
        res.status(200).json(data);
      } else {
        // Unauthorized
        res.status(401).send();
      }
    }
  });
});

module.exports = router;
