const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore.document('appNotifications/{id}')
.onCreate((snapshot, context) => {
    var notificationMessage = snapshot.data().message;

    const payload = {
        notification: {
            title: 'Devfest Levante 2019',
            body: notificationMessage
        }
   };

   return admin.messaging().sendToTopic("devfest_levante_2019", payload)
});

exports.createNotification = functions.firestore.document('createAppNotifications/{id}')
.onCreate((snapshot, context) => {

    var notificationMessage = snapshot.data().message;
    var notificationType = snapshot.data().type;
    
    var timestamp = (new Date()).getTime();
    
    admin.firestore().doc('appNotifications/' + timestamp).set({
        message: notificationMessage,
        timestamp: timestamp,
        type: notificationType === null ? "generic" : notificationType
    }).then(function (snapshot) {
        return admin.firestore().doc('createAppNotifications/' + timestamp).delete();
    }).catch(function (error) {
        return console.log(error);
    });
});