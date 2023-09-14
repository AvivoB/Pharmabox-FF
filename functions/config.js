/* 
* Fichier qui definit les variables d'environnement des clous function
*
*
*
*
*/

const nodemailer = require('nodemailer');


// ONE SIGNAL - Envoie des notifications push
const ONESIGNAL_APP_ID = 'ce23a4c1-57e3-4379-913d-388977c0e0da'; 
const ONESIGNAL_API_KEY = 'YjE0NjlmNjYtMjE1NS00MThmLWJlZTItYTFhYTJiNmYwZGU4';


// EMAILS - Envoie des email depuis le backend
const fromEmail = 'PHARMABOX <pharmaboxdb@gmail.com>';
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


module.exports = {
    ONESIGNAL_APP_ID: ONESIGNAL_APP_ID,
    ONESIGNAL_API_KEY: ONESIGNAL_API_KEY,
    fromEmail: fromEmail,
    transporter: transporter,
    // et tout autre élément que vous souhaitez exporter
  };