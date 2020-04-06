import axios from 'axios';

export default class API {
  static async get(url: string) {
    return new Promise(function(resolve, reject) {
      axios({
        method: 'GET',
        url: url
      })
        .then(function(response: any) {
          resolve(response);
        })
        .catch(function(error: any) {
          reject(error);
        });
    });
  }

  static async post(url: string, data: JSON) {
    return new Promise(function(resolve, reject) {
      axios({
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        data: data,
        url: url
      })
        .then(function(response) {
          resolve(response);
        })
        .catch(function(error) {
          reject(error);
        });
    });
  }
}
