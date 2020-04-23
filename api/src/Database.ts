var mysql = require('mysql');
const util = require('util');

// var DB_CONFIG = require('./config');
import { DB_CONFIG } from "./config";
var logger = require("../logger");

export default class Database {
  private connection: any = null;
  private static db: Database;

  private constructor() {
    this.connection = mysql.createConnection(DB_CONFIG);
  }

  /**
   * Get function for singleton
   */
  public static getInstance(): Database {
    if (Database.db == null) {
      Database.db = new Database();
    }
    return Database.db;
  }

  // Promise based mysql queries from https://codeburst.io/node-js-mysql-and-promises-4c3be599909b
  private query(sql: any) {
    return new Promise((resolve, reject) => {
      this.connection.query(sql, (err: any, rows: any) => {
        if (err)
          return reject(err);
        resolve(rows);
      });
    });
  }

  /**
   * Return a single result
   */
  public async queryFetch(queryText: string, res?: any): Promise<any> {
    var data = await this.query(queryText)
      .then(function(response: any) {
        if (res) {
          res.status(200).json(response[0]);
        } else {
          return response[0];
        }
      })
      .catch(function(error: any) {
        console.log(error);
        logger.error(error);
        if (res) {
          res.status(400).send(error);
        } else {
          return { "error": error }
        }
      });
    return data;
  }

  /**
   * Return multiple results
   */
  public async queryFetchAll(queryText: string, res?: any): Promise<any> {
    var data = await this.query(queryText)
      .then(function(response: any) {
        if (res) {
          res.status(200).json(response);
        } else {
          return response;
        }
      })
      .catch(function(error: any) {
        console.log(error);
        logger.error(error);
        if (res) {
          res.status(400).send(error);
        } else {
          return { "error": error }
        }
      });
    return data;
  }

  private formatInsertValues(insertData: any): any {
    var values = Object.values(insertData);
    for (let i = 0; i < values.length; i++) {
      if (values[i] != "NULL") {
        values[i] = `'${values[i]}'`
      }
    }
    return values.toString();
  }

  public async insert(table: string, insertData: any, res?: any): Promise<any> {
    var keys = Object.keys(insertData).toString();
    var values = this.formatInsertValues(insertData);
    var query = `insert into ${table} (${keys}) values (${values})`;
    var data = await this.query(query)
      .then(async function(response: any) {
        if (res) {
          res.status(200).json(response);
        } else {
          return true;
        }
      })
      .catch(function(error: any) {
        console.log(error);
        logger.error(error);
        if (res) {
          res.status(400).send(error);
        } else {
          return false;
        }
      });
    return data;
  }

  public async isAuthorized(userID: string, authHeader: string): Promise<number> {
    var authToken = authHeader || "";
    authToken = authToken.replace("Basic", "").trim();
    var data = await this.queryFetch(`select username,password from users where id=${userID}`, null);
    if (data) {
      const token = Buffer.from(`${data["username"]}:${data["password"]}`, 'utf8').toString('base64');
      if (token === authToken) {
        return 1;
      }
      return 0;
    }
    return -1;
  }
}
