var fs = require('fs');

function formatOutput(text){
  return getTimestamp() + text + "\n"
}

function getTimestamp(){
  var now = new Date();
  var date = now.toLocaleString();
  return `[${date}] `
}

function getFilePath(logType){
  var currentDate = new Date();
  var date = currentDate.getDate();
  var month = currentDate.getMonth();
  var year = currentDate.getFullYear();
  var monthDateYear  = (month+1) + "-" + date + "-" + year;
  var dir = __dirname + "/" + (month+1) + "-" + year;
  if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
}
  return `${dir}/${monthDateYear}-${logType}.txt`;
}

var Logger = function(){};

Logger.log = function (logTxt) {
  fs.writeFile(getFilePath("log"), formatOutput(logTxt),  {'flag':'a'},  function(err) {
      if (err) {
          return console.error(err);
      }
  });
};

Logger.error = function (logTxt) {
  fs.writeFile(getFilePath("error"), formatOutput(logTxt),  {'flag':'a'},  function(err) {
      if (err) {
          return console.error(err);
      }
  });
};

module.exports = Logger;
