var createError = require('http-errors');
var express = require('express');
var bodyParser = require("body-parser");
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require("cors");
const fileUpload = require('express-fileupload');

// require all the routes
var eventsRouter = require('./endpoints/events');
var weeklongRouter = require('./endpoints/weeklong');
var lockinRouter = require('./endpoints/lockin');
var userRouter = require('./endpoints/user');
var codeRouter = require('./endpoints/code');
var validateRouter = require('./endpoints/validate');
var supplyDropRouter = require('./endpoints/supplydrop');

var app = express();

app.use(fileUpload());

app.use(cors());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// do routing here
app.use('/api', eventsRouter);
app.use('/api', weeklongRouter);
app.use('/api', lockinRouter);
app.use('/api', userRouter);
app.use('/api', codeRouter);
app.use('/api', validateRouter);
app.use('/api', supplyDropRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500).send(err);
});

module.exports = app;
