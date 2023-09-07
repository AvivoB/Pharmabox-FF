const functions = require("firebase-functions");
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const FieldValue = admin.firestore.FieldValue;
const path = require('path');
const fs = require('fs');
const axios = require('axios');

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

  exports.notifyOnAddNetwork = functions.firestore.document('users/{userId}').onWrite(async (change, context) => {
    // Récupère les données du document avant le changement
    const oldData = change.before.data();
    // Récupère les données du document après le changement
    const newData = change.after.data();

    if (newData && newData.reseau && (!oldData || newData.reseau.length > oldData.reseau.length)) {
        // Récupère la dernière entrée ajoutée au tableau `reseau`
        const lastEntry = newData.reseau[newData.reseau.length - 1];

        // Convertit cette entrée en chaîne de caractères (si ce n'est pas déjà une chaîne)
        const lastEntryAsString = lastEntry.toString();

        // Accède à Firestore
        const db = admin.firestore();
        const userId = context.params.userId;

        // Crée un nouveau document dans la collection 'notifications'
        const notificationData = {
            addedToNetwork: true,
            liked: false,
            by_user: lastEntryAsString,
            for: userId,
            timestamp: FieldValue.serverTimestamp(),
        };

        return db.collection('notifications').add(notificationData);
    } else {
        // Si 'reseau' n'est pas dans le document ou si aucune nouvelle entrée n'a été ajoutée, ne fait rien
        return null;
    }
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
exports.sendVerificationCode = functions.firestore
  .document('users/{userId}')
  .onCreate((snap, context) => {
    const user = snap.data();

    /* ENVOI DES EMAILS */
    // Configuration du serveur SMTP
    let transporter = nodemailer.createTransport({
      service: "gmail",
      host: "smtp.gmail.com",
      port: 587,
      secure: false,
      auth: {
          // type: 'OAuth2',
          user: 'pharmaboxdb@gmail.com',
          pass: 'avkjycgnhzignnqc',
      }
  });

    // // Vérification du champ 'poste'
    // if (user.poste !== 'Pharmacien(ne) titulaire') {
    //     console.log('Pas un titulaire, skipping email');
    //     return null;
    // }

    // Génère un code de validation
    let verificationCode = Math.floor(1000 + Math.random() * 9000);


    // Mise à jour du document utilisateur avec le code de validation
    return admin.firestore().collection('users').doc(snap.id).update({
        verificationCode: verificationCode,
        isVerified: false
    }).then(() => {
        // Construire le courriel
        const mailOptions = {
            from: 'PHARMABOX <pharmaboxdb@gmail.com>',
            to: user.email,
            subject: 'Votre code de vérification',
            html: htmlContent.replace('{{code}}', verificationCode)
        };        

        // Envoie le mail
        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error);
                throw new functions.https.HttpsError('internal', 'Failed to send email.');
            }
        });
    }).catch((error) => {
        console.log(error);
        throw new functions.https.HttpsError('internal', 'Failed to update user document.');
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





