class User {
  final String uid;
  final String nom;
  final String prenom;
  final String poste;
  final String email;
  final String telephone;
  final String dateNaissance;
  final String city;
  final String presentation;
  final bool afficherEmail;
  final bool afficherTel;
  final Map<String, String> specialisations;
  final Map<String, String> lgo;
  final Map<String, String> competences;
  final Map langues;
  final Map experiences;
  final bool isValid;
  final bool isComplete;
  final bool isVerified;

  User(
    this.uid,
    this.email,
    this.poste,
    this.nom,
    this.prenom, {
    this.telephone = '',
    this.dateNaissance = '',
    this.city = '',
    this.presentation = '',
    this.afficherEmail = true,
    this.afficherTel = true,
    this.specialisations = const {},
    this.lgo = const {},
    this.competences = const {},
    this.langues = const {},
    this.experiences = const {},
    this.isValid = true,
    this.isComplete = true,
    this.isVerified = true,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        poste = json['poste'],
        nom = json['nom'],
        prenom = json['prenom'],
        telephone = json['telephone'] ?? '',
        dateNaissance = json['dateNaissance'] ?? '',
        city = json['city'] ?? '',
        presentation = json['presentation'] ?? '',
        afficherEmail = json['afficherEmail'] ?? true,
        afficherTel = json['afficherTel'] ?? true,
        specialisations = json['specialisations'] ?? {},
        lgo = json['lgo'] ?? {},
        competences = json['competences'] ?? {},
        langues = json['langues'] ?? {},
        experiences = json['experiences'] ?? {},
        isValid = json['isValid'] ?? true,
        isComplete = json['isComplete'] ?? true,
        isVerified = json['isVerified'] ?? true;
}
