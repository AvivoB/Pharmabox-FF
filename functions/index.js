const functions = require("firebase-functions");
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const path = require('path');
const fs = require('fs');

admin.initializeApp();

// crée une copie des champs utilisateurs en minuscule pour la recherche
exports.searchDataUsers = functions
  .firestore
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
  
  exports.searchDataPharmacie = functions.firestore
    .document('pharmacies/{pharmacieId}')
    .onWrite((change, context) => {
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

    exports.notifyOnAddNetwork = functions.firestore
      .document('users/{userId}')
      .onWrite(async (change, context) => {
          // Récupère les données du document modifié ou créé
          const newData = change.after.data();
          // Vérifie si la clé 'reseau' existe
          if (newData && newData.reseau) {
              // Accède à Firestore
              const db = admin.firestore();
              // Crée un nouveau document dans la collection 'notifications'
              const notificationData = {
                  addedToNetwork: true,
                  liked: false,
                  by_user: newData.reseau,
                  timestamp: FieldValue.serverTimestamp(), 
              };

              return db.collection('notifications').add(notificationData);
          } else {
              // Si 'reseau' n'est pas dans le document, ne fait rien
              return null;
          }
    });

    exports.notifyOnLike = functions.firestore
    .document('like/{likeId}')
    .onCreate(async (snapshot, context) => {
        // Récupère les données du document créé
        const data = snapshot.data();

        // Vérifie si des données sont ajoutés
        if (data) {
            // Accède à Firestore
            const db = admin.firestore();

            // Crée un nouveau document dans la collection 'notifications'
            const notificationData = {
              addedToNetwork: false,
              liked: true,
              by_user: newData.liked_by,
              timestamp: FieldValue.serverTimestamp(),
            };

            return db.collection('notifications').add(notificationData);
        } else {
            // Si 'reseau' n'est pas dans le document, ne fait rien
            return null;
        }
    });






/* ENVOI DES EMAILS */
// Configuration du serveur SMTP
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'pharmaboxdb@gmail.com',
        pass: 'pharmaboxdb5526'
    }
});

const htmlPath = path.join(__dirname, '/email_template/code_validation.html');
const htmlContent = fs.readFileSync(htmlPath, 'utf8');

// Envoi du code de verification du compte
exports.sendVerificationCode = functions.firestore
  .document('users/{userId}')
  .onCreate((snap, context) => {
    const user = snap.data();

    // Vérification du champ 'poste'
    if (user.poste !== 'Pharmacien(ne) titulaire') {
        console.log('Pas un titulaire, skipping email');
        return null;
    }

    // Génère un code de validation
    let verificationCode = Math.floor(1000 + Math.random() * 9000);

    // Mise à jour du document utilisateur avec le code de validation
    return admin.firestore().collection('users').doc(snap.id).update({
        verificationCode: verificationCode
    }).then(() => {
        // Construire le courriel
        const mailOptions = {
            from: 'pharmaboxdb@gmail.com',
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





