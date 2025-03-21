// Make Formatter Phone Number 06 00 00 00 00
export const formatPhoneNumber = (phoneNumber: string) => {
    // Nettoyer et limiter à 10 chiffres
    const cleaned = phoneNumber.replace(/\D/g, '').slice(0, 10);
    
    // Formatter au fur et à mesure de la saisie
    let formatted = '';
    for (let i = 0; i < cleaned.length; i++) {
        if (i > 0 && i % 2 === 0) {
            formatted += ' ';
        }
        formatted += cleaned[i];
    }
    
    return formatted;
};


export const formatDate = (date: string) => {
    // Nettoyer les caractères non numériques
    const cleaned = date.replace(/\D/g, '').slice(0, 8);
    
    // Formatter avec des /
    let formatted = '';
    for (let i = 0; i < cleaned.length; i++) {
        if (i === 2 || i === 4) {
            formatted += '/';
        }
        formatted += cleaned[i];
    }
    
    // Vérifier la validité de la date
    if (cleaned.length === 8) {
        const day = parseInt(cleaned.slice(0, 2));
        const month = parseInt(cleaned.slice(2, 4));
        const year = parseInt(cleaned.slice(4, 8));
        
        // if (day > 31 || month > 12) {
        //     return 'error';
        // }
    }
    
    return formatted;
};


export const formatNumberSecu = (nsecu: string) => {
    // Formatter un N° de sécurité sociale FR
    // Format : X XX XX XX XXX XXX XX
    const cleaned = nsecu.replace(/\D/g, '').slice(0, 15);

    let formatted = '';

    for (let i = 0; i < cleaned.length; i++) {
        if (i === 1 || i === 3 || i === 5 || i === 7 || i === 10 || i === 13) {
            formatted += ' ';
        }
        formatted += cleaned[i];
    }

    return formatted;
}

export const formatIban = (iban: string) => {
    // Format : FR76 3000 4028 3798 7654 3210 943
    const cleaned = iban.replace(/\s/g, '').toUpperCase().slice(0, 27);

    let formatted = '';

    for (let i = 0; i < cleaned.length; i++) {
        if (i > 0 && i % 4 === 0) {
            formatted += ' ';
        }
        formatted += cleaned[i];
    }

    return formatted;
}

export const formatDateFirebase = (dateString: string) => {
    if (!dateString) return '';
    
    try {
      // Si c'est un timestamp Firebase (objet Firestore)
      if (dateString.seconds) {
        const date = new Date(dateString.seconds * 1000);
        return date.toLocaleDateString('fr-FR', { 
          day: '2-digit', 
          month: '2-digit', 
          year: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        });
      }
      
      // Si c'est une chaîne de date standard
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR', { 
        day: '2-digit', 
        month: '2-digit', 
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch (error) {
      console.log('Erreur de formatage de date:', error);
      return dateString; // Retourne la date originale en cas d'erreur
    }
  };