
const express = require("express");
const jwt = require('jsonwebtoken');
const app = express();
const cors = require("cors");
const admin = require('firebase-admin');
const env = require('./config');
const axios = require('axios');
const { user } = require("firebase-functions/v1/auth");
app.use(cors({ origin: true }));
const PORT = 3005;
const secretKey = 'fgeighzgaieqdbzaehfdgbayilu5fed54e45e4d4z44d4ez4e4de4z4d4ez4derft4r4tfg4';

app.use(express.json());
app.use(cors())

// Middleware de vérification de token
function verifyToken(req, res, next) {

    // Récuperer le token depuis Bearer
    const bearerHeader = req.headers['authorization'];
    if (!bearerHeader) {
        return res.status(403).send
        ({ message: 'Token manquant.' });

    }
    const bearer = bearerHeader.split(' ');
    const token = bearer[1];

    if (!token) {
        return res.status(403).send({ message: 'Token manquant.' });
    }

    jwt.verify(token, secretKey, (err, decoded) => {
        if (err) {
            return res.status(401).send({ message: 'Session expiré ! Merci de vous reconnecter.' });
        }
        next();
    });
}

app.get("/", (req, res) => {
    return res.status(200).send("Hi there what is up");
});


authorisedUsers = [
    {email: 'pharmabox-admin@pharmabox.fr', password: 'Pharmabox2023-XNZJ-pk2'},
]

// Route de connexion pour générer et stocker le token dans un cookie
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
  
    
    // Compare from local user en dure
    if (authorisedUsers.some(user => user.email === email && user.password === password)) {
      const userId = 1; // ID utilisateur fictif
      const token = jwt.sign({ id: userId }, secretKey, { expiresIn: '1h' });
  
      // Stocker le token dans un cookie
      res.cookie('token', token, { httpOnly: true });
  
      return res.status(200).send({ message: 'Connexion réussie', token: token });
    } else {
      return res.status(401).send({ message: 'Identifiants incorrects' });
    }
});


app.get('/users', verifyToken, async (req, res) => {

    // try {
        const users = await admin.auth().listUsers();
        const firestoreUsersSnapshot = await admin.firestore().collection('users').get();


        const firestoreUsersMap = {};
        firestoreUsersSnapshot.forEach(doc => {
            firestoreUsersMap[doc.id] = doc.data();
        });

        // Mapper les utilisateurs en associant les données Firestore
        const usersData = users.users.map(user => {
            const firestoreUser = firestoreUsersMap[user.uid];
            return {
                id: user.uid,
                photoUrl: firestoreUser?.photoUrl ?? '',
                telephone: firestoreUser?.telephone ?? '',
                name: firestoreUser ? `${firestoreUser.nom} ${firestoreUser.prenom}` : 'Nom non disponible',
                email: user.email,
                fcm_token: firestoreUser?.fcmToken ?? '',
                poste: firestoreUser?.poste ?? '',
                authMethod: user.providerData[0]?.providerId || 'Méthode inconnue',
                created_at: user.metadata.creationTime,
                last_sign_in_at: user.metadata.lastSignInTime,
                last_activity: user.metadata.lastRefreshTime,
                isComplete: firestoreUser?.isComplete ?? false,
                isValid: firestoreUser?.isValid ?? false,
            };
        });

        return res.status(200).send(usersData);
    // } catch (error) {
    //     return res.status(400).send(error);
    // }
});


app.get('/pharmacies', verifyToken,  async (req, res) => {
    try {
        const pharmacies = await admin.firestore().collection('pharmacies').get();        

        const pharmaciesData = pharmacies.docs.map(pharmacy => {
            const pharmacie = pharmacy.data();

            return {
                id: pharmacie.id,
                name: pharmacie.situation_geographique.adresse,
                location: pharmacie.situation_geographique.data.ville+', '+ pharmacie.situation_geographique.data.country,
                titulaire: pharmacie.titulaire_principal.toString().toUpperCase() ?? '',
                groupement: pharmacie.groupement[0].name ?? '',
                isComplete: pharmacie.isComplete ?? false,
                isValid: pharmacie.isValid ?? false,
                created_at: new Date(pharmacy.createTime._seconds * 1000),
            };
        });

        return res.status(200).send(pharmaciesData);
    } catch (error) {
        return res.status(400).send(error);
    }
});

app.post('/create-notification', verifyToken, async (req, res) => {
    const { title, body, token} = req.body;
    try {

        const tokens = token.split(',').map(token => token.trim());

        const message = {
            notification: {
                title: title,
                body: body,
            },
            tokens: tokens,
        };
        const response = await admin.messaging().sendEachForMulticast(message);

        if(response.failureCount > 0) {
            return res.status(400).send({
                message: 'Erreur lors de l\'envoi de la notification en masse, ' + response.failureCount + ' échecs d\'envoi',
                response: response.responses,
            });
        }

        return res.status(200).send(response);
    } catch (error) {
        return res.status(400).send(error);
    }
});





app.post('/create-template', verifyToken, async (req, res) => {
    const { name, html, editor_data } = req.body;

    if (!name || !html) {
        return res.status(400).send({
            message: 'Le nom et le contenu HTML sont requis.'
        });
    }

    try {
        // Enregistre le template dans le dossier templates
        const filePath = `backoffice/email_template/${name}.html`;
        const bucket = admin.storage().bucket('pharmaff-dab40.appspot.com');

        await bucket.file(filePath).save(html, {
            contentType: 'text/html', // Définit le type MIME du fichier
            resumable: false, // Sauvegarde en une seule étape
        });

        await bucket.file(filePath.replace('.html', '.json')).save(editor_data, {
            contentType: 'application/json',
            resumable: false,
        });

        return res.status(200).send({
            message: `Template '${name}' enregistré avec succès.`
        });

    } catch (error) {
        return res.status(500).send({
            message: 'Erreur interne lors de l\'enregistrement du template.',
            error: error,
        });
    }
});

app.get('/templates', verifyToken, async (req, res) => {

    try {
        const bucket = admin.storage().bucket('pharmaff-dab40.appspot.com');
        
        // Récupération des fichiers dans le dossier spécifié
        const [files] = await bucket.getFiles({
            prefix: 'backoffice/email_template/',
        });
    
        // Extraction des noms des fichiers JSON et HTML uniquement
        const fileNames = files.map(file => file.name.split('/').pop());
        const htmlFiles = fileNames.filter(name => name.endsWith('.html')).map(name => name.split('.').shift());
        const jsonFiles = fileNames.filter(name => name.endsWith('.json')).map(name => name.split('.').shift());
    
        // Association des fichiers HTML et JSON ayant le même nom
        const templatesToProcess = htmlFiles.filter(name => jsonFiles.includes(name));
    
        // Traitement des templates associés
        const templates = await Promise.all(
            templatesToProcess.map(async (fileName) => {
                try {
                    // URL signée pour le fichier JSON
                    const [signedUrl] = await bucket.file(`backoffice/email_template/${fileName}.json`).getSignedUrl({
                        action: 'read',
                        expires: Date.now() + 1000 * 60 * 5, // 5 minutes
                    });
    
                    // Récupération des données JSON
                    const response = await axios.get(signedUrl);
                    const jsonData = response.data;
    
                    return {
                        name: fileName,
                        data_editor: jsonData,
                    };
                } catch (innerError) {
                    console.error(`Erreur lors du traitement du fichier ${fileName}:`, innerError.message);
                    return null; // Permet de continuer même si un fichier échoue
                }
            })
        );
    
        // Filtrer les templates valides
        const validTemplates = templates.filter(template => template !== null);
    
        console.log(validTemplates);
    
        return res.status(200).send({
            templates: validTemplates,
        });
    } catch (error) {
        console.error('Erreur lors de la récupération des templates:', error.message);
        return res.status(500).send({
            message: 'Erreur interne lors de la récupération des templates.',
        });
    }    

});

app.post('/send-newsletter', verifyToken, async (req, res) => {
    const { subject, emails, html } = req.body;

    errors = [];
    if (!subject) {
        errors.push('Le sujet du mail est requis.');
    }
    if (!html) {
        errors.push('Le html est requis.');
    }
    if (!emails) {
        errors.push('Les emails sont requis.');
    }

    if (errors.length > 0) {
        return res.status(400).send({
            message: 'Erreur : ' + errors.join(', ')
        });
    }

    try {
        try {

            var originalHtmlContent = html

        } catch (error) {
            if (error.code === 404) {
                return res.status(404).send({
                    message: `Template "${template_name}" introuvable dans le bucket. ${error.message}`
                });
            }
            throw error;
        }
        
        // Convertir les emails en tableau
        const emailList = Array.from(new Set(emails.split(',').map(email => email.trim()))); // Éliminer les doublons

        // Récupérer tous les utilisateurs concernés dans Firestore en une seule requête
        const usersSnapshot = await admin
            .firestore()
            .collection('users')
            .where('email', 'in', emailList)
            .get();
        
        if (usersSnapshot.empty) {
            return res.status(404).send({
                message: 'Aucun utilisateur trouvé pour les emails spécifiés.'
            });
        }



        // Mapper les utilisateurs en associant les données Firestore
        const usersData = usersSnapshot.docs.map(doc => {
            const userData = doc.data();
            return {
                id: doc.id,
                email: userData.email,
                nom: userData.nom ?? '',
                prenom: userData.prenom ?? '',
                poste: userData.poste ?? '',
            };
        });

        emailPromises = [];

        usersData.forEach(user => {
            // Cloner le contenu HTML pour chaque utilisateur
            let personalizedHtml = originalHtmlContent;
        
            // Remplacer les placeholders dynamiquement
            personalizedHtml = personalizedHtml
                .replace(/{{nom}}/g, user.nom ?? '')
                .replace(/{{prenom}}/g, user.prenom ?? '')
                .replace(/{{poste}}/g, user.poste ?? '');
        
            const mailOptions = {
                from: env.fromEmail,
                to: user.email,
                subject: subject,
                html: personalizedHtml,
            };
        
            emailPromises.push(env.transporter.sendMail(mailOptions));
        });
        
        // Attendre que tous les emails soient envoyés
        await Promise.all(emailPromises);

        return res.status(200).send({
            message: `La newsletter a été envoyée à ${emailList.length} utilisateurs.`,
        });
    } catch (error) {
        console.error('Erreur lors de l\'envoi de la newsletter :', error);
        return res.status(500).send('Erreur interne lors de l\'envoi de la newsletter. :' + error);
    }
});


app.get('/dynamic-message', verifyToken, async (req, res) => {

    try {
        const dynamicMessage = await admin.firestore().collection('dynamic_message').doc('accueil').get();

        if (!dynamicMessage.exists) {
            return res.status(404).send({
                message: 'Message dynamique introuvable.'
            });
        }

        return res.status(200).send(dynamicMessage.data());
    } catch (error) {
        return res.status(500).send({
            message: 'Erreur interne lors de la récupération du message dynamique.'
        });
    }

});

app.post('/change-dynamic-message', verifyToken, async (req, res) => {

    // collection dynamic_message document dynamic_message
    const { text, title, color1, color2, link, button_text } = req.body;

    try {
        await admin.firestore().collection('dynamic_message').doc('accueil').set({
            text: text,
            title: title,
            color1: color1,
            color2: color2,
            link: link,
            button_text: button_text,
        });

        return res.status(200).send({
            message: 'Message dynamique mis à jour avec succès.'
        });
    } catch (error) {
        return res.status(500).send({
            message: 'Erreur interne lors de la mise à jour du message dynamique.'
        });
    }

});


app.get('/pharmablabla', verifyToken, async (req, res) => {
    
        // try {
            // Get collection pharmablabla
            const pharmablabla = await admin.firestore().collection('pharmablabla').get();
            const users = await admin.firestore().collection('users').get();

            // Mapper les pharmablabla en associant les users
            const pharmablablaData = pharmablabla.docs.map(pharmablabla => {
                const user = users.docs.find(user => user.id === pharmablabla.data().userId);
                return {
                    id: pharmablabla.id,
                    user: user ? `${user.data().nom} ${user.data().prenom}` : 'Utilisateur inconnu',
                    name: pharmablabla.data().name,
                    post_content: pharmablabla.data().post_content,
                    views: pharmablabla.data().users_viewed.length || 0,
                    network: pharmablabla.data().network,
                    date_created: new Date(pharmablabla.data().date_created._seconds * 1000),   
                };
            });

            const openPharmablabla = await admin.firestore().collection('statistics').where('action', '==', 'Open Pharmablabla').get();
            const openPost = await admin.firestore().collection('statistics').where('action', '==', 'Open Pharmablabla Post').get();

            const statistics = {
                total_posts: pharmablablaData.length,
                open_pharmablabla: openPharmablabla.docs.map(pharmablabla => pharmablabla.data()),
                open_post: openPost.docs.map(openPost => openPost.data()),
            };
    
            return res.status(200).send({
                posts: pharmablablaData,
                statistics: statistics,
            });
        // } catch (error) {
        //     return res.status(500).send({
        //         message: 'Erreur interne lors de la récupération du pharmablabla.',
        //         error: error,
        //     });
        // }
    
});

app.get('/annuaire', verifyToken, async (req, res) => {
    
        try {
            
            // From Google Sheets API
            // https://script.google.com/macros/s/AKfycbxrqjg978ezEg4gI4lM_BPIWoS_bIay5cQItBBsBCG4AK22rE3qtcRsRiYAkiTrLT4uLw/exec

            const data  = axios.get('https://script.google.com/macros/s/AKfycbxrqjg978ezEg4gI4lM_BPIWoS_bIay5cQItBBsBCG4AK22rE3qtcRsRiYAkiTrLT4uLw/exec')
        
            const openAnnuaire = await admin.firestore().collection('statistics').where('action', '==', 'Open Annuaire').get();

            const statistics = {
                open_annuaire: openAnnuaire.docs.map(annauireItem => annauireItem.data()),
            };
        data.then((response) => {
            return res.status(200).send({
                annuaire: response.data,
                statistics: statistics,
            });
        }
        ).catch((error) => {
            console.log('Error', error);
            return res.status(500).send({
                message: 'Erreur interne lors de la récupération de l\'annuaire.'
            });
        }
        );
        } catch (error) {
            return res.status(500).send({
                message: 'Erreur interne lors de la récupération de l\'annuaire.'
            });
        }
    
});


   
module.exports = {
    app: app,
};