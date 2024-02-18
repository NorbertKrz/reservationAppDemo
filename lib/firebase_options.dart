// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBcFpJmJ1MJa8Fd30nnYoxBdri6FV9oxPc',
    appId: '1:581837960739:web:1101462364b4d6bea56396',
    messagingSenderId: '581837960739',
    projectId: 'reservationapp-6d7a5',
    authDomain: 'reservationapp-6d7a5.firebaseapp.com',
    databaseURL: 'https://reservationapp-6d7a5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'reservationapp-6d7a5.appspot.com',
    measurementId: 'G-519KW1LGND',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2bwYs4L-Z0uSrYL4BxgNwSYfpZ5P8w7M',
    appId: '1:581837960739:android:0f3fedcfc8d8ab08a56396',
    messagingSenderId: '581837960739',
    projectId: 'reservationapp-6d7a5',
    databaseURL: 'https://reservationapp-6d7a5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'reservationapp-6d7a5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4yX0B_JT-jD-WJ1lJs-EWXBLcm1Sggvw',
    appId: '1:581837960739:ios:3fafaf3fa9b57d55a56396',
    messagingSenderId: '581837960739',
    projectId: 'reservationapp-6d7a5',
    databaseURL: 'https://reservationapp-6d7a5-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'reservationapp-6d7a5.appspot.com',
    iosBundleId: 'com.example.buzz',
  );
}
