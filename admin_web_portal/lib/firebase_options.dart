// Firebase configuration for the Dierb production project.
// A dedicated Firebase Web app can replace the appId later without changing the data model.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError('Dierb Firebase options are not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBVUGFEPhyNrFwkMjEuV4PGk7EEQS_CQ5I',
    appId: '1:365123606367:android:82969f06df11aba2b8c8ea',
    messagingSenderId: '365123606367',
    projectId: 'dierb-29548',
    authDomain: 'dierb-29548.firebaseapp.com',
    storageBucket: 'dierb-29548.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVUGFEPhyNrFwkMjEuV4PGk7EEQS_CQ5I',
    appId: '1:365123606367:android:82969f06df11aba2b8c8ea',
    messagingSenderId: '365123606367',
    projectId: 'dierb-29548',
    storageBucket: 'dierb-29548.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVUGFEPhyNrFwkMjEuV4PGk7EEQS_CQ5I',
    appId: '1:365123606367:android:82969f06df11aba2b8c8ea',
    messagingSenderId: '365123606367',
    projectId: 'dierb-29548',
    storageBucket: 'dierb-29548.firebasestorage.app',
  );
}
