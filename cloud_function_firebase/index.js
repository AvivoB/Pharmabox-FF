/* 
* CLOUD FUNCTIONS
*
* Ce fichier permet de gerer les cloud function firebase 
* pour declencher les notifications push et manipulation 
*
*/

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Envoie des notifications a la personne qui reçoit un message via la messagerie
exports.sendNotificationOnNewMessage = functions.firestore
  .document('messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    // Récupérer les données du nouveau message
    const messageData = snapshot.data();
    const receiverId = messageData.receiverId;

    // Récupérer les informations de l'utilisateur destinataire
    const userSnapshot = await admin.firestore().collection('users').doc(receiverId).get();
    const userData = userSnapshot.data();
    const fcmToken = userData.fcmToken;

    // Construire le message de notification
    const notificationPayload = {
      notification: {
        title: 'Nouveau message',
        body: 'Vous avez reçu un nouveau message',
      },
    };

    // Envoyer la notification push à l'utilisateur
    await admin.messaging().sendToDevice(fcmToken, notificationPayload);
    
    console.log('Notification sent to user:', receiverId);
  });

