const functions = require("firebase-functions");
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const FieldValue = admin.firestore.FieldValue;
const path = require('path');
const fs = require('fs');
const axios = require('axios');
const env = require('./config');

admin.initializeApp();

// crée une copie des champs utilisateurs en minuscule pour la recherche
exports.searchDataUsers = functions.firestore.document('users/{userId}').onWrite((change, context) => {
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
  
// Applatissement des données pour la recherche et enregistrement de la donnée dans le document
  function flattenData(data, prefix = '') {
    let result = {};
  
    for (const [key, value] of Object.entries(data)) {
      if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
        result = { ...result, ...flattenData(value, `${prefix}${key}_`) };
      } else if (Array.isArray(value)) {
        result[`${prefix}${key}`] = value.map(item => typeof item === 'string' ? item.toLowerCase() : item);
      } else if (typeof value === 'string') {
        result[`${prefix}${key}`] = value.toLowerCase();
      } else {
        result[`${prefix}${key}`] = value;
      }
    }
  
    return result;
  }

  function formatDateToDDMMYYYY(date) {
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-based in JS
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
}

  function flattenDataOffres(data) {
    const flattenedData = {};

    flattenedData.nom = data.nom || "";
    flattenedData.localisation = data.localisation || "";
    flattenedData.rayon = data.rayon || "";
    flattenedData.contrats = data.contrats.join(", ") || "";
    flattenedData.duree = data.duree || "";
    flattenedData.temps = data.temps || "";
    flattenedData.debut_immediat = data.debut_immediat;
    flattenedData.debut_contrat = data.debut_contrat || "";
    flattenedData.salaire_mensuel = data.salaire_mensuel || "";
    flattenedData.grille_horaire = data.grille_horaire.map(week => week.semaine.join(", ")).join(" | ");
    flattenedData.grille_pair_impaire_identique = data.grille_pair_impaire_identique;
    flattenedData.grille_horaire_impaire = data.grille_horaire_impaire.map(week => week.semaine.join(", ")).join(" | ");
    flattenedData.proposition_dispo_interim = data.proposition_dispo_interim.map(dateTime => formatDateToDDMMYYYY(dateTime.toDate())).join(", ");
    flattenedData.user_id = data.user_id || "";
    flattenedData.date_created = data.date_created; // Assuming you keep this as a timestamp for querying purposes
    flattenedData.isActive = data.isActive;
  
    return flattenedData;
  }
  
  exports.searchDataPharmacie = functions.firestore.document('pharmacies/{pharmacieId}').onWrite((change, context) => {
      // Get the document
      const document = change.after.exists ? change.after.data() : null;
  
      // Proceed if the document exists
      if (document) {
        const searchData = flattenData(document);
  
        // Update the document's search data in a subcollection
        return admin.firestore()
          .collection('pharmacies')
          .doc(context.params.pharmacieId)
          .collection('searchDataPharmacie')
          .doc(context.params.pharmacieId)
          .set(searchData);
      } else {
        return null;
      }
  });

  exports.searchDataRecherche = functions.firestore.document('recherches/{rechercheId}').onWrite((change, context) => {
      // Get the document
      const document = change.after.exists ? change.after.data() : null;
  
      // Proceed if the document exists
      if (document) {
        const searchData = flattenData(document);
  
        // Update the document's search data in a subcollection
        return admin.firestore()
          .collection('recherches')
          .doc(context.params.rechercheId)
          .collection('searchDataRecherche')
          .doc(context.params.rechercheId)
          .set(searchData);
      } else {
        return null;
      }
  });

  exports.searchDataOffre = functions.firestore.document('offres/{offreId}').onWrite((change, context) => {
      // Get the document
      const document = change.after.exists ? change.after.data() : null;
  
      // Proceed if the document exists
      if (document) {
        const searchData = flattenDataOffres(document);
  
        // Update the document's search data in a subcollection
        return admin.firestore()
          .collection('offres')
          .doc(context.params.offreId)
          .collection('searchDataOffre')
          .doc(context.params.offreId)
          .set(searchData);
      } else {
        return null;
      }
  });

  exports.notifyOnAddNetwork = functions.firestore.document('demandes_network/{demande}').onCreate(async (snapshot, context) => {

        const data = snapshot.data();
        // Accède à Firestore
        const db = admin.firestore();
        // Crée un nouveau document dans la collection 'notifications'
        const notificationData = {
            addedToNetwork: true,
            liked: false,
            by_user: data.by_user,
            for: data.for,
            timestamp: FieldValue.serverTimestamp(),
        };

        db.collection('notifications').add(notificationData);
});


  exports.notifyOnLike = functions.firestore.document('likes/{likeId}').onCreate(async (snapshot, context) => {
      // Récupère les données du document créé
      const data = snapshot.data();
      // Accède à Firestore
      const db = admin.firestore();

      // Crée un nouveau document dans la collection 'notifications'
      const notificationData = {
        addedToNetwork: false,
        liked: true,
        by_user: data.liked_by,
        for: data.document_id,
        timestamp: FieldValue.serverTimestamp(),
      };

      return db.collection('notifications').add(notificationData);
  });



const htmlPath = path.join(__dirname, '/email_template/code_validation.html');
const htmlContent = fs.readFileSync(htmlPath, 'utf8');

// Envoi du code de verification du compte
exports.updateUserOnCreate = functions.firestore
  .document('users/{userId}')
  .onCreate((snap, context) => {

    // Mise à jour du document utilisateur avec le code de validation
    return admin.firestore().collection('users').doc(snap.id).update({
        isVerified: false,
        isComplete: false,
        isValid: false,
    }).then(() => {

    }).catch((error) => {
        console.log(error);
        throw new functions.https.HttpsError('internal', 'Failed to update user document.');
    });
});


exports.sendCodeVerification = functions.https.onRequest((req, res) => {
  // Vérifiez que vous avez l'ID de l'utilisateur dans la demande
  if (!req.body.userId) {
      res.status(400).send('User ID is required');
      return;
  }
  const userId = req.body.userId;

  // Génère un nouveau code de validation
  let newVerificationCode = Math.floor(1000 + Math.random() * 9000);

  admin.firestore().collection('users').doc(userId).update({
      verificationCode: newVerificationCode,
  }).then(() => {
      return admin.firestore().collection('users').doc(userId).get();
  }).then(doc => {
      if (!doc.exists) {
          throw new Error('User not found');
      }
      const user = doc.data();

      // Construire le courriel
      const mailOptions = {
          from: env.fromEmail, // utilisez votre configuration d'environnement
          to: user.email,
          subject: 'Votre code de validation Pharmabox',
          html: htmlContent.replace('{{code}}', newVerificationCode)
      };        

      // Envoie le mail
      return env.transporter.sendMail(mailOptions); // utilisez votre configuration d'environnement
  }).then(() => {
      res.status(200).send('Verification code resent successfully');
  }).catch((error) => {
      console.log(error);
      res.status(500).send('Failed to resend verification code');
  });
});


const ONESIGNAL_APP_ID = 'ce23a4c1-57e3-4379-913d-388977c0e0da'; 
const ONESIGNAL_API_KEY = 'YjE0NjlmNjYtMjE1NS00MThmLWJlZTItYTFhYTJiNmYwZGU4';

exports.sendNotificationOnMessage = functions.firestore
    .document('messages/{messageId}/message/{docId}')
    .onCreate(async (snap, context) => {
        const data = snap.data();
        // retarde la fonction de 1.5s pour verifier si l'utilisateur est sur la discussion
        await new Promise(resolve => setTimeout(resolve, 1500));

        if(data.isViewed == false) {
            const receiverId = data.receiverId;
            const messageContent = data.message;
    
            // Metadata
            const metadata = {
              'receiverId': data.receiverId,
              'fromId': data.fromId
          };
    
            const notificationContent = {
              app_id: ONESIGNAL_APP_ID,
              headings: { "en": "Nouveau message" },
              contents: { "en": messageContent },
              include_external_user_ids: [receiverId],
              'data': metadata
          };
    
          try {
              const response = await axios.post('https://onesignal.com/api/v1/notifications', notificationContent, {
                  headers: {
                      'Content-Type': 'application/json',
                      'Authorization': `Basic ${ONESIGNAL_API_KEY}`
                  }
              });
    
              console.log('Notification sent', response.data);
          } catch (e) {
              console.error('Error sending notification', e);
          }
        }

        return null;
});



exports.sendMailDesactivePharmacie = functions.firestore
  .document('pharmacies/{pharmacieId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue.isValid === false && previousValue.isValid === true) {

      const userId = newValue.user_id;

      // Récupérer les informations de l'utilisateur depuis la collection 'users'
      const userDoc = await admin.firestore().collection('users').doc(userId).get();
      const userData = userDoc.data(); 

      const MailDesactivationPath = path.join(__dirname, '/email_template/desactivation_pharmacie.html');
      const MailDesactivationContent = fs.readFileSync(MailDesactivationPath, 'utf8');

      const mailOptions = {
        from: env.fromEmail,
        to: userData['email'],
        subject: 'Votre pharmacie a été désactivée',
        html: MailDesactivationContent
    };        
      // Envoie le mail
      return env.transporter.sendMail(mailOptions); // utilisez votre configuration d'environnement
    }

    return null;
});

exports.sendMailDesactiveCompte = functions.firestore
  .document('users/{ueserId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue.isValid === false && previousValue.isValid === true) {
      // Le champ 'isValid' a changé de true à false
      const userEmail = newValue.email; // Assurez-vous que votre document contient le champ 'email'

      const MailComptePath = path.join(__dirname, '/email_template/desactivation_compte.html');
      const MailDesactivationCompteContent = fs.readFileSync(MailComptePath, 'utf8');

      const mailOptions = {
        from: env.fromEmail,
        to: userEmail,
        subject: 'Votre compte a été désactivée',
        html: MailDesactivationCompteContent
    };        
      // Envoie le mail
      return env.transporter.sendMail(mailOptions); // utilisez votre configuration d'environnement
    }

    return null;
});


exports.deleteAccount = functions.https.onRequest( async (req, res) => {
  
  if (!req.body.userId) {
    res.status(400).send('User ID is required');
    return;
  }
  // Récupérez l'id de l'utilisateur
  const userId = req.body.userId;

  console.log('suppression du compte: ' + userId);

  const demandeNetworkRef = admin.firestore().collection('demandes_network');
  const demandeNetwork1 = await demandeNetworkRef.where('by_user', '==', userId).get();
  const demandeNetwork2 = await demandeNetworkRef.where('for', '==', userId).get();

  const likesRef = admin.firestore().collection('likes');
  const likes1 = await likesRef.where('document_id', '==', userId).get();
  const likes2 = await likesRef.where('liked_by', '==', userId).get();

  const notificationsRef = admin.firestore().collection('notifications');
  const notifications1 = await notificationsRef.where('by_user', '==', userId).get();
  const notifications2 = await notificationsRef.where('for', '==', userId).get();

  const offresRef = admin.firestore().collection('offres');
  const offres = await offresRef.where('user_id', '==', userId).get();

  const recherchesRef = admin.firestore().collection('recherches');
  const recherches = await recherchesRef.where('user_id', '==', userId).get();

  const pharmablablaRef = admin.firestore().collection('pharmablabla');
  const pharmablabla = await pharmablablaRef.where('userId', '==', userId).get();

  const pharmaciesRef = admin.firestore().collection('pharmacies');
  const pharmacies = await pharmaciesRef.where('user_id', '==', userId).get();


  const signalementsRef = admin.firestore().collection('notifications');
  const signalements1 = await signalementsRef.where('docId', '==', userId).get();
  const signalements2 = await signalementsRef.where('fromId', '==', userId).get();

  const usersRef = admin.firestore().collection('users');

  const network = await usersRef.where('reseau', 'array-contains', userId).get();

  

  const users = await usersRef.where('uid', '==', userId).get();

  const messagesRef = await admin.firestore().collection("messages");
  const messages = await messagesRef.get();




 
  const deletePromises = [];
    // demandes_network
    demandeNetwork1.forEach((doc) => {
      console.log('suppression des demandes réseau')
      deletePromises.push(doc.ref.delete());
    });
    demandeNetwork2.forEach((doc) => {
      console.log('suppression des demandes réseau')
      deletePromises.push(doc.ref.delete());
    });

    // Likes
    likes1.forEach((doc) => {
      console.log('suppression des likes')
      deletePromises.push(doc.ref.delete());
    });
    likes2.forEach((doc) => {
      console.log('suppression des likes')
      deletePromises.push(doc.ref.delete());
    });

    // notifications
    notifications1.forEach((doc) => {
      console.log('suppression des notifications')
      deletePromises.push(doc.ref.delete());
    });
    notifications2.forEach((doc) => {
      console.log('suppression des notifications')
      deletePromises.push(doc.ref.delete());
    });

    // Offres
    offres.forEach((doc) => {
      console.log('suppression des offres')
      deletePromises.push(doc.ref.delete());
    });
    // recherches
    recherches.forEach((doc) => {
      console.log('suppression des recherches')
      deletePromises.push(doc.ref.delete());
    });
    // Pharmablabla
    pharmablabla.forEach((doc) => {
      console.log('suppression des post pharmablabla')
      deletePromises.push(doc.ref.delete());
    });
    // Pharmacies
    pharmacies.forEach((doc) => {
      console.log('suppression de la paharmacie ')
      deletePromises.push(doc.ref.delete());
    });

    // Signalements
    signalements1.forEach((doc) => {
      console.log('suppression des signalements')
      deletePromises.push(doc.ref.delete());
    });
    signalements2.forEach((doc) => {
      console.log('suppression des signalements')
      deletePromises.push(doc.ref.delete());
    });

    // Mise a jour du réseau des autres
    network.forEach(async (doc) => {
      const reseauArray = doc.data().reseau || [];
      console.log('suppression du réseau')
      // Supprimer 'userId' du tableau
      reseauArrayFiltered = reseauArray.filter(id => id !== userId);
      deletePromises.push(doc.ref.update({ reseau: reseauArrayFiltered }));
    });

      
    messages.forEach((document) => {
      console.log('suppression des messages')
      // Supprimez le document si son nom contient l'ID de l'utilisateur
      if (document.id.includes(userId)) {
        deletePromises.push(document.ref.delete());
      }
    });

    // Users
    users.forEach((doc) => {
      console.log('suppression de l\'utilisateur')
      deletePromises.push(doc.ref.delete());
    });

    
    await Promise.all(deletePromises);

    await admin.auth().deleteUser(userId);
});






