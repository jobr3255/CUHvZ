/**
 * This file is a modified version of node-php-password developed by Thomas Alrek in order to incorporate it into typescript
 *
 * @package node-php-password
 * @copyright (c) 2016, Thomas Alrek
 * @author Thomas Alrek <thomas@alrek.no>
 */

var aliases = {
  PASSWORD_DEFAULT: "PASSWORD_BCRYPT"
}

/* hold all algorithm modules */
var algorithms = {};

// Import bcrypt algorithm and add to algorithms list
var bcrypt = require('./bcrypt.js');
algorithms[bcrypt.name] = bcrypt;

/* check if any modules where loaded, otherwise throw error */
if(algorithms.length === 0){
    throw("exception no algorithms loaded");
}

var Password = function(){};

/**
 * Get information from password hash
 * @param {string} hash A password hash to check
 * @return {object} Info object
 * @throws {Exception} Will throw an exception if unable to parse hash
 */
Password.getInfo = function (hash){
    var found = false;
    var info = {
        algoName: "",
        options: {
            cost: 0
        }
    };
    for(var key in algorithms){
        algorithms[key].expression.lastIndex = 0;
        if(algorithms[key].expression.test(hash)){
            info.algoName = algorithms[key].name;
            info.options.cost = algorithms[key].cost(hash);
            found = true;
            break;
        }
    }
    if(!found){
        throw("exception unknown algorithm");
    }
    return info;
}

/**
 * Hash a password string
 * @param {string} password The plaintext password to hash
 * @param {string} algorithm Algorithm name, e.g "PASSWORD_DEFAULT"
 * @param {object} options Options to pass to the hashing algorithm
 * @return {string} Password hash
 * @throws {Exception} Will throw an exception if an invalid algorithm is passed
 */
Password.hash = function (password, algorithm, options){
    var algo;
    if(typeof algorithm == 'undefined'){
        algorithm = "PASSWORD_DEFAULT";
    }
    if(typeof options == 'undefined'){
        options = {};
    }
    if(typeof aliases[algorithm] !== 'undefined'){
        algorithm = aliases[algorithm];
    }
    if(typeof algorithms[algorithm] == 'undefined'){
        throw("exception unknown algorithm");
    }
    algo = algorithms[algorithm];
    return algo.hash(password, options);
}

/**
 * Check if a given password needs to be rehashed
 * @param {string} hash A password hash to check
 * @param {string} algorithm Algorithm name, e.g "PASSWORD_DEFAULT"
 * @param {object} options Options to pass to the hashing algorithm
 * @return {bool} true if password needs rehash, otherwise false
 * @throws {Exception} Will throw an exception if an invalid algorithm is passed
 */
Password.needsRehash = function (hash, algorithm, options){
    var info = {};
    try{
        info = Password.getInfo(hash);
    }catch(e){
        /* unable to parse hash, so we assume it's an old or unknown format */
        return true;
    }
    /* check if the supplied algorithm name is an alias */
    if(typeof aliases[algorithm] !== 'undefined'){
        algorithm = aliases[algorithm];
    }
    /* unable to compare, because an invalid algorithm was supplied */
    if(typeof algorithms[algorithm] == 'undefined'){
        throw("exception unknown algorithm");
    }
    if(algorithms[algorithm].name === info.algoName){
        if(typeof options !== 'undefined' && typeof options.cost !== 'undefined'){
            if(info.options.cost < options.cost){
                return true;
            }
        }
        return false;
    }
    return true;
}

/**
 * Verify a plaintext password against hash
 * @param {string} password The plaintext password to check
 * @param {string} hash A password hash to check
 * @return {bool} true if password is verified against given hash, otherwise false
 * @throws {Exception} Will throw an exception if unable to parse hash
 */
Password.verify = function (password, hash){
    var info = Password.getInfo(hash);
    return algorithms[info.algoName].verify(password, hash);
}

module.exports = Password;
