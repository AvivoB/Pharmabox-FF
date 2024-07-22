const puppeteer = require('puppeteer');
const axios = require('axios');
const fs = require('fs');
const xlsx = require('xlsx');

// Liste des lettres de l'alphabet
const alphabet = ['0', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']; 
const EXCEL_FILE = './laboratoires.xlsx';

// Créer le dossier "laboratoires" s'il n'existe pas déjà
if (!fs.existsSync('laboratoires')) {
    fs.mkdirSync('laboratoires');
}

var jsonData = [];

// Créer le fichier Excel s'il n'existe pas
if (!fs.existsSync(EXCEL_FILE)) {
    // Avant de commencer le traitement, lire le fichier Excel une seule fois
    var workbook = xlsx.readFile(EXCEL_FILE);
    var worksheet = workbook.Sheets['Laboratoires'];
    jsonData = xlsx.utils.sheet_to_json(worksheet);
} else {
    // Si le fichier Excel existe déjà, on le supprime pour éviter les doublons
    fs.unlinkSync(EXCEL_FILE);
    var workbook = xlsx.utils.book_new();
    var worksheet = xlsx.utils.json_to_sheet([]);
    xlsx.utils.book_append_sheet(workbook, worksheet, 'Laboratoires');
    xlsx.writeFile(workbook, EXCEL_FILE);
    jsonData = [];
}



// Fonction pour créer un délai
function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

console.log('Téléchargement des laboratoires en cours...');

(async () => {
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();

    for (const letter of alphabet) {
        const url = `https://www.labodata.com/annuaire-des-laboratoires/${letter}`;
        await page.goto(url, { waitUntil: 'networkidle2' });

        // Récupération des informations des laboratoires
        const laboratoires = await page.$$eval('div.card', cards => {
            return cards.map(card => {
                const nameElement = card.querySelector('h2 > strong');
                const addressElement = card.querySelector('div.card .card-footer').cloneNode(true);
                const strongElements = addressElement.querySelectorAll('strong');
                strongElements.forEach(el => el.remove());

                const descriptionElement = card.querySelector('div.card .card-body .small');

                const phoneElement = card.querySelector('div.card .card-footer small');
                const emailElement = card.querySelector('.card-footer > a.text-ld-primary');
                
                // const websiteElement = card.querySelector('.small a.card-link');
                // Get wtiht target _blank
                const websiteElement = card.querySelector('.card-body > a[target="_blank"]');
                const imageElement = card.querySelector('img');


                const name = nameElement ? nameElement.innerText : '';
                const desription = descriptionElement ? descriptionElement.innerText : '';
                const address = addressElement && addressElement != 'Voir les produits  disponibles dans la base de données' ? addressElement.innerText : '';
                const phone = phoneElement ? phoneElement.innerText : '';
                // Email has 2 element get second
                const email = emailElement && !emailElement.href.startsWith('https') ? emailElement.href.replace('mailto:', '') : '';
                const website = websiteElement ? websiteElement.href : '';
                const imageUrl = imageElement ? imageElement.src : '';
                return { name, desription, address, phone, email, website, imageUrl };
            });
        });
        

        // Utiliser Promise.all pour télécharger toutes les images en parallèle
        const downloadPromises = laboratoires.map(async (laboratoire) => {
            const { name, desription, address, phone, email, website, imageUrl } = laboratoire;
            const nameCleaned = name.replace(/[^a-zA-Z0-9-_]/g, '');
            const nomFichier = `${nameCleaned}.jpg`;
            const path = `laboratoires/${nomFichier}`;

            if (imageUrl) {

                // await sleep(5000);

                // Téléchargement de l'image
                // const response = await axios({
                //     url: imageUrl,
                //     responseType: 'stream',
                // });
                // await new Promise((resolve, reject) => {
                //     const stream = response.data.pipe(fs.createWriteStream(path));
                //     stream.on('finish', resolve);
                //     stream.on('error', reject);
                // });
            }

            // Ajouter les données dans jsonData au lieu de les écrire immédiatement dans le fichier Excel
            jsonData.push({ name, desription, address, phone, email, website, imageUrl});
        });


        // Console log de chaque element email
        laboratoires.forEach((laboratoire) => {
            console.log(laboratoire);
        });

        // Attendre que tous les téléchargements soient terminés
        await Promise.all(downloadPromises);

        console.log(`Téléchargement terminé pour les laboratoires commençant par ${letter}`);
        // await page.waitForTimeout(5000);
    }

    await browser.close();

    // Écrire les données dans le fichier Excel une seule fois
    const newWorksheet = xlsx.utils.json_to_sheet(jsonData);
    workbook.Sheets['Laboratoires'] = newWorksheet;
    xlsx.writeFile(workbook, EXCEL_FILE);

    // Create JSON
    fs.writeFileSync('./laboratoires.json', JSON.stringify(jsonData, null, 2));
    console.log('Fichier laboratoires.json créé avec succès');

    // Creer SQL
    // let sqlData = 'INSERT INTO laboratoires (name, description, image, address, phone, email, website) VALUES\n';
    // jsonData.forEach((laboratoire, index) => {
    //     const { name, desription, image, address, phone, email, website } = laboratoire;
    //     sqlData += `('${name}', '${desription}', '${image}', '${address}', '${phone}', '${email}', '${website}')`;
    //     if (index !== jsonData.length - 1) {
    //         sqlData += ',\n';
    //     }
    // });

    // fs.writeFileSync('laboratoires/laboratoires.sql', sqlData);
    // console.log('Fichier laboratoires.sql créé avec succès');
})();


