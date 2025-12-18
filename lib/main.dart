import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_chat/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_simple_chat/screens/chat_screen.dart';
import 'package:flutter_simple_chat/screens/splash_screen.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            final user = snapshot.data as User;
            if (user.emailVerified) {
              return ChatScreen();
            } else {
              return const AuthScreen();
            }
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
