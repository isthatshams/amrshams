import 'package:amrshams/chat.dart';
import 'package:amrshams/sign_in.dart';
import 'package:amrshams/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCqdzPfUC3i-UA6eKJ97whNyXADNrmnk_4",
          authDomain: "shams-522f7.firebaseapp.com",
          projectId: "shams-522f7",
          storageBucket: "shams-522f7.appspot.com",
          messagingSenderId: "694922258443",
          appId: "1:694922258443:web:902c2974b9f796f42bf0fe",
          databaseURL: "https://shams-522f7-default-rtdb.firebaseio.com"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      initialRoute: '/',
      routes: {
        '/': (context) => const SignIn(),
        '/sign_up': (context) => const SignUp(),
        '/home': (context) => const ChatScreen(),
      },
    );
  }
}
