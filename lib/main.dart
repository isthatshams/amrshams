import 'package:amrshams/chat.dart';
import 'package:amrshams/sign_in.dart';
import 'package:amrshams/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
