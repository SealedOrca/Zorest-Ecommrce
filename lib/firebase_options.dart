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
        return macos;
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
    apiKey: 'AIzaSyAQwvGVThttEUDlLhWG5fD8ncFGiWkr25c',
    appId: '1:134472072398:web:31bb281b029fa9f8e8649f',
    messagingSenderId: '134472072398',
    projectId: 'fam1-b4d5b',
    authDomain: 'fam1-b4d5b.firebaseapp.com',
    databaseURL: 'https://fam1-b4d5b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fam1-b4d5b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2kx92BKOK59iG1BYmwdPB6_bIKqFUQmc',
    appId: '1:134472072398:android:a249d7d6e77b8e74e8649f',
    messagingSenderId: '134472072398',
    projectId: 'fam1-b4d5b',
    databaseURL: 'https://fam1-b4d5b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fam1-b4d5b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpZKwEoiP_c_sDMGfWz8mVRLSX-p-VaZ8',
    appId: '1:134472072398:ios:b867100013ca37b1e8649f',
    messagingSenderId: '134472072398',
    projectId: 'fam1-b4d5b',
    databaseURL: 'https://fam1-b4d5b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fam1-b4d5b.appspot.com',
    iosClientId: '134472072398-7j6es00jai671m0r5jt2d40kfjh97lj5.apps.googleusercontent.com',
    iosBundleId: 'com.example.fam1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpZKwEoiP_c_sDMGfWz8mVRLSX-p-VaZ8',
    appId: '1:134472072398:ios:8f05ef6d56906647e8649f',
    messagingSenderId: '134472072398',
    projectId: 'fam1-b4d5b',
    databaseURL: 'https://fam1-b4d5b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fam1-b4d5b.appspot.com',
    iosClientId: '134472072398-0g01cp3bptu2rf9v3dk60pdmmbhs9dvs.apps.googleusercontent.com',
    iosBundleId: 'com.example.fam1.RunnerTests',
  );
}