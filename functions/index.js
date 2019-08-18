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
.onCreate(snapshot => {

    var notificationMessage = snapshot.data().message;
    var notificationType = snapshot.data().type === undefined ? "generic" : snapshot.data().type;
    
    var timestamp = (new Date()).getTime();
    
    return admin.firestore().doc('appNotifications/' + timestamp).set({
        message: notificationMessage,
        timestamp: timestamp,
        type: notificationType
    }).then(function (snapshot2) {
        return admin.firestore().doc(snapshot.ref.path).delete();
    }).catch(function (error) {
        return console.log(error);
    });
});