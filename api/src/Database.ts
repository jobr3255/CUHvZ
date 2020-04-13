var mysql = require('mysql')

var CONFIG = require('./config')
var logger = require("../logger");

export default class Database {
  private connection: any = null;
  private static db: Database;

  private constructor() {
    this.connection = mysql.createConnection(CONFIG);
  }

  public static getInstance(): Database {
    if (Database.db == null) {
      Database.db = new Database();
    }
    return Database.db;
  }

  public queryFetch(queryText: string, res?: any): any {
    this.connection.query(queryText, function(err: any, data: any) {
      if (err) {
        console.log(err);
        logger.error(err);
        if (res) {
          res.status(400).send(err);
        }
        return false;
      }
      if (res) {
        res.status(200).json(data[0]);
      }
      return data[0];
    })
  };

  public queryFetchAll(queryText: string, res?: any): any {
    this.connection.query(queryText, function(err: any, data: any) {
      if (err) {
        console.log(err);
        logger.error(err);
        if (res) {
          res.status(400).send(err);
        }
        return false;
      }
      if (res) {
        res.status(200).json(data);
      }
      return data;
    })
  };

  private formatInsertValues(insertData: any): any {
    var values = Object.values(insertData);
    for (let i = 0; i < values.length; i++) {
      if (values[i] != "NULL") {
        values[i] = `'${values[i]}'`
      }
    }
    return values.toString();
  }

  public insert(table: string, insertData: any, res?: any): any {
    var keys = Object.keys(insertData).toString();
    var values = this.formatInsertValues(insertData);
    var query = `insert into ${table} (${keys}) values (${values})`;
    this.connection.query(query , function(err: any, data: any) {
      if (err) {
        console.log(err);
        logger.error(err);
        if (res) {
          res.status(400).send(err);
        }
        return false;
      }
    })
    return this.queryFetch("SELECT LAST_INSERT_ID()", res);
  }
}
