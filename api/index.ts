var createError = require('http-errors');
var express = require('express');
var bodyParser = require("body-parser");
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require("cors");
// const fileUpload = require('express-fileupload');

// require all the routes
var eventsRouter = require('./src/endpoints/events');
var weeklongRouter = require('./src/endpoints/weeklong');
var lockinRouter = require('./src/endpoints/lockin');
var userRouter = require('./src/endpoints/user');
var codeRouter = require('./src/endpoints/code');
var validateRouter = require('./src/endpoints/validate');
var supplyDropRouter = require('./src/endpoints/supplydrop');
var myLogger = require("./logger");

const app = express();

// app.use(fileUpload());

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
app.use(function(_req: any, _res: any, next: any) {
  next(createError(404));
});

// error handler
app.use(function(err: any, req: any, res: any, _next: any) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500).send(err);
});

/**
 * Module dependencies.
 */
var debug = require('debug')('api:server');
var http = require('http');

/**
 * Get port from environment and store in Express.
 */

var port = normalizePort(process.env.PORT || '9000');
app.set('port', port);

/**
 * Create HTTP server.
 */

var server = http.createServer(app);

/**
 * Listen on provided port, on all network interfaces.
 */

server.listen(port);
server.on('error', onError);
server.on('listening', onListening);

/**
 * Normalize a port into a number, string, or false.
 */

function normalizePort(val: any) {
  var port = parseInt(val, 10);

  if (isNaN(port)) {
    // named pipe
    return val;
  }

  if (port >= 0) {
    // port number
    return port;
  }

  return false;
}

/**
 * Event listener for HTTP server "error" event.
 */

function onError(error: any) {
  if (error.syscall !== 'listen') {
    throw error;
  }

  var bind = typeof port === 'string'
    ? 'Pipe ' + port
    : 'Port ' + port;

  // handle specific listen errors with friendly messages
  switch (error.code) {
    case 'EACCES':
      console.error(bind + ' requires elevated privileges');
      myLogger.error(bind + ' requires elevated privileges');
      process.exit(1);
    case 'EADDRINUSE':
      console.error(bind + ' is already in use');
      myLogger.error(bind + ' is already in use');
      process.exit(1);
    default:
      throw error;
  }
}

/**
 * Event listener for HTTP server "listening" event.
 */

function onListening() {
  var addr = server.address();
  var bind = typeof addr === 'string'
    ? 'pipe ' + addr
    : 'port ' + addr.port;
  debug('Listening on ' + bind);
  console.log('Listening on ' + bind);
  myLogger.log('Listening on ' + bind);
}
