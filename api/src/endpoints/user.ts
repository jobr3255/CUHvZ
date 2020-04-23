var express = require("express");
var router = express.Router();
var Password = require("node-php-password");
import Token from "../Token";
var nodemailer = require('nodemailer');

import Database from "../Database";
import { EMAIL_CONFIG } from "../config";
var logger = require("../../logger");

router.get("/users", function(_req: any, res: any) {
  let db: Database = Database.getInstance();
  db.queryFetchAll('SELECT username,email,phone from users', res);
});

function sendActivationEmail(email: string, activationCode: string) {
  var body = `<p>Thank you for registering to play Humans vs Zombies at CU Boulder.</p><p>To activate your account, please click on this link: <a href='cuhvz.com/activate/${activationCode}'>Activate your account</a></p><p>- CU BOULDER HVZ TEAM</p>`
  var mailOptions = {
    from: 'no-reply@cuhvz.com',
    to: email,
    subject: 'Activate your HvZ account',
    text: `Activate your account cuhvz.com/activate/${activationCode}`,
    html: body
  };
  let transporter = nodemailer.createTransport(EMAIL_CONFIG);
  transporter.verify(function(error: any, _success: any) {
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

router.post('/user/new', async function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var data = req.body;
  data.password = Password.hash(req.body.password, "PASSWORD_BCRYPT");
  var response = await db.insert("users", data, null);
  if (response) {
    var userData = await db.queryFetch("select * from users where id=LAST_INSERT_ID()", null);
    var userEmail = userData["email"];
    var userID = userData["id"];
    var activateCode = Token(20);
    var tokenData = {
      user_id: userID,
      token: activateCode,
      type: "activation"
    };
    db.insert("tokens", tokenData, null);
    sendActivationEmail(userEmail, activateCode);
    res.status(200).json(userData);
  } else {
    res.status(500).send();
  }
});

router.post('/user/resendactivation', async function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var userID = req.body.userID;
  var authHeader = req.headers.authorization;
  var auth = await db.isAuthorized(userID, authHeader);
  if (auth > 0) {
    var data = await db.queryFetch(`select * from users where id=${userID}`, null);
    if (!data) {
      // Not found
      res.status(404).send();
    } else {
      var userEmail = data["email"];
      var userID = data["id"];
      var activateCode = Token(20);
      var tokenData = {
        user_id: userID,
        token: activateCode,
        type: "activation"
      };
      if (await db.insert("tokens", tokenData, null)) {
        sendActivationEmail(userEmail, activateCode);
        res.status(200).send();
      }
    }
  } else if (auth === -1) {
    res.status(404).send();
  } else {
    res.status(401).send();
  }
});

router.post('/user/edit', function(_req: any, _res: any) {
});

router.post('/user/login', async function(req: any, res: any) {
  let db: Database = Database.getInstance();
  var user = req.body.user;
  var pass = req.body.password;
  var data = await db.queryFetch(`select * from users where (username="${user}" OR email="${user}")`, null);
  // console.log(data);
  if (!data) {
    // Not found
    res.status(404).send();
  } else if (data["error"]) {
    // Bad request
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

module.exports = router;
