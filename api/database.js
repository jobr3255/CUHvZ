var mysql = require('mysql')

var CONFIG = require('./config')
var logger = require("./logs/logger");

var connection = mysql.createConnection(CONFIG);
// connection.connect()
// connection.end()

const STATUS = {
  200: "OK",
  201: "Created",
  400: "Bad Request",
  401: "Unauthorized",
  403: "Forbidden",
  404: "Not Found",
  409: "Conflict"
};


var Database = function(){};
Database.query = function (queryText, res=null) {
  connection.query(queryText, function (err, data, fields) {
    if(err) {
      console.log(err);
      logger.error(err);
      if(res){
        res.status(400).send(err);
      }
      return false;
    }
    if(res){
      res.status(200).json(data);
    }
    return data;
  })
};

Database.queryFetch = function (queryText, res=null) {
  connection.query(queryText, function (err, data, fields) {
    if (err) {
      console.log(err);
      logger.error(err);
      if(res){
        res.status(400).send(err);
      }
      return false;
    }
    if(res){
      res.status(200).json(data[0]);
    }
    return data[0];
  })
};

Database.queryFetchAll = function (queryText, res=null) {
  connection.query(queryText, function (err, data, fields) {
    if (err) {
      console.log(err);
      logger.error(err);
      if(res){
        res.status(400).send(err);
      }
      return false;
    }
    if(res){
      res.status(200).json(data[0]);
    }
    return data;
  })
};

function formatInsertValues(insertData){
  var values = Object.values(insertData);
  for(let i = 0; i < values.length; i++){
    if(values[i] != "NULL"){
      values[i] = `'${values[i]}'`
    }
  }
  return values.toString();
}

Database.insert = function (table, insertData, res=null) {
  var keys = Object.keys(insertData).toString();
  var values = formatInsertValues(insertData);
  connection.query(`insert into ${table} (${keys}) values (${values})`, function (err, data, fields) {
    if (err) {
      console.log(err);
      logger.error(err);
      if(res){
        res.status(400).send(err);
      }
      return false;
    }
    return Database.queryFetchSingle("SELECT LAST_INSERT_ID()", res);
  })
};

module.exports = Database;
