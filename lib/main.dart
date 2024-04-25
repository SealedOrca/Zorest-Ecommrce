import 'package:fam1/Screens/login/Register/walkthroughpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zorest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor:  const Color.fromARGB(255, 86, 150, 107)),
          useMaterial3: true,
        ),
        home: const WalkthroughPage());
  }
}
