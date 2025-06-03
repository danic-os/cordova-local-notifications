var exec = require('cordova/exec');

exports.sendNotification = function (arg0, success, error) {
    exec(success, error, 'LocalNotifications', 'sendNotification', [arg0]);
};


exports.askPermission = function (arg0, success, error) {
    exec(success, error, 'LocalNotifications', 'askPermission', [arg0]);
};
