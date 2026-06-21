import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUvel8rITpEBFDNPk_cLWPgBiQte0lrRQ',
    authDomain: 'voca-7fc0f.firebaseapp.com',
    projectId: 'voca-7fc0f',
    storageBucket: 'voca-7fc0f.firebasestorage.app',
    messagingSenderId: '738740052899',
    appId: '1:738740052899:web:755a965cd4a8087e19f016',
    measurementId: 'G-S05ZS9PM41',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUvel8rITpEBFDNPk_cLWPgBiQte0lrRQ',
    authDomain: 'voca-7fc0f.firebaseapp.com',
    projectId: 'voca-7fc0f',
    storageBucket: 'voca-7fc0f.firebasestorage.app',
    messagingSenderId: '738740052899',
    appId: '1:738740052899:web:755a965cd4a8087e19f016',
    measurementId: 'G-S05ZS9PM41',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUvel8rITpEBFDNPk_cLWPgBiQte0lrRQ',
    authDomain: 'voca-7fc0f.firebaseapp.com',
    projectId: 'voca-7fc0f',
    storageBucket: 'voca-7fc0f.firebasestorage.app',
    messagingSenderId: '738740052899',
    appId: '1:738740052899:web:755a965cd4a8087e19f016',
    measurementId: 'G-S05ZS9PM41',
  );
}
