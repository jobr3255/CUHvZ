var express = require("express");
var router = express.Router();
var Password = require("node-php-password");
var nodemailer = require('nodemailer');

import Database from "../Database";
import { EMAIL_CONFIG } from "../config";
var logger = require("../../logger");

router.get("/users", function(_req: any, res: any) {
  let db: Database = Database.getInstance();
  db.queryFetchAll('SELECT username,email,phone from users', res);
});

function sendActivationEmail(email: string, activationCode: string){
  var body = `<p>Thank you for registering to play Humans vs Zombies at CU Boulder.</p><p>To activate your account, please click on this link: <a href='cuhvz.com/activate/${activationCode}'>Activate your account</a></p><p>- CU BOULDER HVZ TEAM</p>`
  var mailOptions = {
    from: 'no-reply@cuhvz.com',
    to: email,
    subject: 'Activate your HvZ account',
    text: `Activate your account cuhvz.com/activate/${activationCode}`,
    html: body
  };
  let transporter = nodemailer.createTransport(EMAIL_CONFIG);
  transporter.verify(function(error: any, success: any) {
    if (error) {
      logger.error(error);
      console.log(error);
    } else {
      console.log("Sending email...");
      transporter.sendMail(mailOptions, function(error: any, info: { response: string; }) {
        if (error) {
          logger.error(error);
          console.log(error);
        } else {
          console.log('Email sent: ' + info.response);
        }
      });
    }
  });
}

router.post('/user/new', function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var data = req.body;
  data.password = Password.hash(req.body.password, "PASSWORD_BCRYPT");
  db.insert("users", data, null, (data: any) => {
    if (data) {
      db.queryFetch("select * from users where id=LAST_INSERT_ID()", null, (data: any) => {
        var userData = data;
        var userEmail = data["email"];
        var userID = data["id"];
        var activateCode = Password.hash(Math.random().toString(36), "PASSWORD_BCRYPT");
        activateCode = activateCode.substr(8, activateCode.length).split("/").join("");
        var tokenData = {
          user_id: userID,
          token: activateCode,
          type: "activation"
        };
        db.insert("tokens", tokenData, null, (data: any) => {
          sendActivationEmail(userEmail, activateCode);
          res.status(200).json(userData);
        });
      });
    } else {
      res.status(500).send();
    }
  });
});

router.post('/user/resendactivation', function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var userID = req.body.userID;
  var email = req.body.email;
  db.queryFetch(`select * from users where id=${userID} and email="${email}"`, null, (data: any) => {
    var userEmail = data["email"];

    var userID = data["id"];
    var activateCode = Password.hash(Math.random().toString(36), "PASSWORD_BCRYPT");
    activateCode = activateCode.substr(8, activateCode.length).split("/").join("");
    var tokenData = {
      user_id: userID,
      token: activateCode,
      type: "activation"
    };
    db.insert("tokens", tokenData, null, (data: any) => {
      sendActivationEmail(userEmail, activateCode);
      res.status(200).send();
    });
  });
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
        delete data["password"];
        res.status(200).json(data);
      } else {
        // Unauthorized
        res.status(401).send();
      }
    }
  });
});

module.exports = router;
