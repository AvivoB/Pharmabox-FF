
# Pharmabox Flutter

Application Flutter Pharmabox

## Configuration requise

 - Flutter : 3.7.12
 - Dart : 2.19.6
 - Branche : dev-aviel
 - Projet Firebase : pharmaff-dab40
 - Notifications push : OneSignal
 

## Installation du projet en local

Clonez ce repository sur votre ordinateur et dans le dossier du projet lancez cette commande

```bash
flutter pub get
```
Si il y a des erreurs lancer cette commande :
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

Pour lancer le projet en emulateur

```bash
flutter run
```

## Functions Firebase

Les functions de ce projets sont situés dans le dossier 'functions'.

Pour tester localement firebase :
```bash
firebase start:emulators
```

Pour lancer le deploiement des functions :

```bash
firebase deploy --only functions
```
## Hosting Firebase

Dans le dossier .well-knwown se situe les fichiers pour les deeplinks IOS et Android.

- La page "profilView" permet de rediriger vers le profil utilisateur
- La page "pharmacieProfilView" permet de rediriger vers le profil pharmacie

Pour lancer le deploiement du Hosting :

```bash
firebase deploy --only hosting
```

#### Tester les deeplinks
```bash
cd C:\Users\Aviel\AppData\Local\Android\Sdk\platform-tools
```
```bash
adb shell
```
```bash
am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://pharmaff-dab40.web.app/whateverpath"
```


## Builder l'application pour Android
#### Générer la clé SHA-1 et SHA-256
```bash
keytool -list -v -keystore "C:\Users\Aviel\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Génerer une clé keystore pour le déploiement Android :
```bash
keytool -genkey -v -keystore release-key.keystore -alias release-key -keyalg RSA -keysize 2048 -validity 10000
```

#### Générer l'application release APK
Générer la clé de signature
```bash
keytool -genkey -v -keystore C:\Users\<username>\upload-keystore.jks ^ -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^ -alias key-release
```
Dans /android/key.properties mettre cela (si le fichier n'existe pas, le créer)
```bash
storePassword=aea12f5305
keyPassword=aea12f5305
keyAlias=key-release
storeFile=C:/Users/<username>/upload-keystore.jks
```

```bash
flutter clean
flutter pub get
```
```bash
flutter build appbundle
```

## Builder l'application pour IOS
#### Effacer les dépendances qui posent soucis
```bash
flutter clean
```
```bash
flutter pub get
```
```bash
pod install
```
```bash
pod update
```
#### Builder l'application IOS
```bash
flutter build
```