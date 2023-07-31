const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp();

// crée une copie des champs utilisateurs en minuscule pour la recherche
exports.updateSearchData = functions.firestore
  .document('users/{userId}')
  .onWrite((change, context) => {
    // Get the document
    const document = change.after.exists ? change.after.data() : null;

    // Proceed if the document exists
    if (document) {
      // Create the search data object by mapping all string fields to lowercase
      const searchData = {};
      for (const [key, value] of Object.entries(document)) {
        if (typeof value === 'string') {
          searchData[key] = value.toLowerCase();
        } else {
          searchData[key] = value;
        }
      }

      // Update the document's search data in a subcollection
      return admin.firestore()
        .collection('users')
        .doc(context.params.userId)
        .collection('searchData')
        .doc(context.params.userId)
        .set(searchData);
    } else {
      return null;
    }
  });

// Permet de d'enregistrer une notification lors de l'ajout au reseau
exports.createNotificationOnNetworkUpdate = functions.firestore
.document('users/{userId}')
.onUpdate(async (change, context) => {
// Get the current and previous value of 'reseau'
const beforeReseau = change.before.data().reseau;
const afterReseau = change.after.data().reseau;

// Check if 'reseau' field has changed
if (JSON.stringify(beforeReseau) !== JSON.stringify(afterReseau)) {
    // Create a new notification document
    const notification = {
        type: 'network',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        userId: afterReseau,
    };

    await admin.firestore().collection('notifications').add(notification);
}
});

// Crée une notification push lors de l'enregistrement au reseau
exports.sendPushNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snapshot, context) => {
    const notification = snapshot.data();

    // You'll need to retrieve the FCM token of the user you want to send the notification to.
    // Here, we'll assume you have a 'users' collection, and each user document contains an 'fcmToken' field.
    const userDoc = await admin.firestore().collection('users').doc(notification.userId).get();
    const user = userDoc.data();
    const fcmToken = user.fcmToken;

    const payload = {
      notification: {
        title: 'Nouvelle notification',
        body: `Vous avez été ajouté`,
      },
    };

    if (fcmToken) {
      await admin.messaging().sendToDevice(fcmToken, payload);
    }
  });








