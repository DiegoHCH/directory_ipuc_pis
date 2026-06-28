// Generado a partir de google-services.json y GoogleService-Info.plist
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está disponible para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDnZaFsHLJgF87cKqq0ccT90mXessNJtaY',
    appId: '1:804660931161:web:e60cef4256dc9a0dc79f48',
    messagingSenderId: '804660931161',
    projectId: 'ipuc-pis-directory',
    storageBucket: 'ipuc-pis-directory.firebasestorage.app',
    authDomain: 'ipuc-pis-directory.firebaseapp.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlt9s3wKeaM1W2Hsp3txpNUIb63tim5l0',
    appId: '1:804660931161:android:27e68838fa0ea335c79f48',
    messagingSenderId: '804660931161',
    projectId: 'ipuc-pis-directory',
    storageBucket: 'ipuc-pis-directory.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCg9dLpSFjAZA2sZauDXpc3T21WalzqyKg',
    appId: '1:804660931161:ios:0ba6223b87036ee6c79f48',
    messagingSenderId: '804660931161',
    projectId: 'ipuc-pis-directory',
    storageBucket: 'ipuc-pis-directory.firebasestorage.app',
    iosBundleId: 'co.ipuc.pis.directory',
  );
}
