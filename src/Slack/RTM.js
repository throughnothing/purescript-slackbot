// module Slack.RTM
'use strict';

var RtmClient = require('@slack/client').RtmClient;

exports._client = function (creds) {
    var params = {logLevel: "info"};
    return new RtmClient(creds.token, params);
};

exports._start = function(client) {
    return function() { client.start(); };
};

exports._send = function (client) {
  return function(id) {
    return function(msg) {
      return function() {
        client.sendMessage(msg, id);
      }
    }
  }
}

exports._listen = function (client) {
  return function(eventName) {
    return function(error) {
      return function(success) {
        return function() {
          try {
            client.on(eventName, function(x){
              success(x)();
            });
          } catch(e) {
              error(e)();
          }
        }
      }
    }
  }
}

exports._log = function(x) {
  return function() {
    console.log(x);
  }
}
