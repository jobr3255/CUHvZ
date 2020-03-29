import axios from 'axios';

export default class API{
  static get = async (url) => {
    return new Promise(function(resolve, reject) {
      const options = {
        method: 'GET',
        url: url
      };
      axios(options)
      .then(function (response) {
        resolve(response);
      })
      .catch(function (error) {
        reject(error);
      });
    });
  }

  static post = (url, data, headers=null) => {
    return new Promise(function(resolve, reject) {
      const options = {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        data: data,
        url: url
      };
      console.log("do post");
      axios(options)
      .then(function (response) {
        resolve(response);
      })
      .catch(function (error) {
        reject(error);
      });
    });
  }
}
