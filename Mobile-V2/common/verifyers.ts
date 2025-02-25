export const verifyEmail = (mail: string) : boolean => {
    // Nettoyer les espaces et convertir en minuscules
    const cleaned = mail.trim().toLowerCase();
    
    // Si l'email est vide ou en cours de saisie (pas de @ ou .), retourner la valeur
    if (!cleaned.includes('@') || !cleaned.includes('.')) {
        return false;
    }
    
    // Regex pour valider le format email complet
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    
    // Vérifier format uniquement si l'email semble complet
    if (!emailRegex.test(cleaned)) {
        return false;
    }
    
    return true;
};


// Verify Phone Number
export const verifyPhoneNumber = (phoneNumber: string) => {
    // Nettoyer et limiter à 10 chiffres et doit commencer par 06 ou 07

    const cleaned = phoneNumber.replace(/\D/g, '').slice(0, 10);
    if (!cleaned.startsWith('06') && !cleaned.startsWith('07')) {
        return false;
    }

    return true;
}


export const verifyNumberSecu = (nsecu: string) => {
    // Format : X XX XX XX XXX XXX XX
    const cleaned = nsecu.replace(/\D/g, '').slice(0, 15);
    if (cleaned.length !== 15) {
        return false;
    }

    return true;
}


export const verifyIban = (iban: string) => {
    // Format : FR76 3000 4028 3798 7654 3210 943
    const cleaned = iban.replace(/\s/g, '').toUpperCase();
    // Vérifier la longueur
    if (cleaned.length !== 27) {
        return false;
    }

    // Vérifier le format sur AA25 5555 5555 5555 5555 5555 555
    if(!/^[A-Z]{2}\d{25}$/.test(cleaned)) {
        console.log(cleaned);
        return false;
    }

    return true;
}