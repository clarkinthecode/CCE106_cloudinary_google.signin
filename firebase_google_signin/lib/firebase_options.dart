import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEFVZ_9LOGH1XBQHLJMOlgR1dtlbXxXBc',
    appId: '1:196805640444:android:ba2fb3ba0e725763e91779',
    messagingSenderId: '196805640444',
    projectId: 'sign-in-5483b',
    storageBucket: 'sign-in-5483b.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDEFVZ_9LOGH1XBQHLJMOlgR1dtlbXxXBc',
    appId: '1:196805640444:web:ba2fb3ba0e725763e91779',
    messagingSenderId: '196805640444',
    authDomain: 'sign-in-5483b.firebaseapp.com',
    projectId: 'sign-in-5483b',
    storageBucket: 'sign-in-5483b.firebasestorage.app',
  );
}
