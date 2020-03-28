var express = require("express");
var router = express.Router();

router.get("/weeklong/:id", function(req, res, next) {
});

router.get("/weeklong/:id/players", function(req, res, next) {
});

router.get("/weeklong/:id/details", function(req, res, next) {
});

router.get("/weeklong/:id/:playerid", function(req, res, next) {
});

router.post('/weeklong/new', function(req, res) {
});

router.post('/weeklong/edit', function(req, res) {
});

router.post('/weeklong/logkill', function(req, res) {
});

module.exports = router;
