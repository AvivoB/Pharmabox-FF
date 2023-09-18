import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../notifications/firebase_notifications_service.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyDzOeYwPkHoAQ63WMuWyrEeYxcU7d1O9pw", authDomain: "pharmaff-dab40.firebaseapp.com", projectId: "pharmaff-dab40", storageBucket: "pharmaff-dab40.appspot.com", messagingSenderId: "402993811587", appId: "1:402993811587:web:3e128a4fd82114ae2b0bb6"));
  } else {
    await Firebase.initializeApp();
  }
}
