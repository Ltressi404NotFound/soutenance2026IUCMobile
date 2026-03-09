import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Nécessaire pour la traduction globale
import 'services/translation_service.dart'; // Ton service de traduction
import 'views/hopital_carner_page.dart'; // Vérifie que le nom du fichier correspond
import 'package:firebase_auth/firebase_auth.dart'; // Nécessaire pour passer l'UID

// Import des vues
import 'views/splash_screen.dart';
import 'views/intro_page.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/emergency_page.dart';
import 'views/firstaid_steps_page.dart';
import 'views/profile_page.dart';
import 'views/chat_page.dart'; // Import de la Chatbox

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD3BELz6CbpNxMFQoRbK_PYeEaH8iUL6Xw",
        appId: "1:745360660470:android:4acf4562b2cd3b0c0659d7",
        messagingSenderId: "745360660470",
        projectId: "loum-epilepsie",
        storageBucket: "loum-epilepsie.firebasestorage.app",
      ),
    );
  } catch (e) {
    await Firebase.initializeApp();
  }

  // On enveloppe l'app avec le TranslationService pour la langue globale
  runApp(
    ChangeNotifierProvider(
      create: (context) => TranslationService(),
      child: const FirstAidApp(),
    ),
  );
}

class FirstAidApp extends StatelessWidget {
  const FirstAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    // L'app "écoute" maintenant les changements de langue
    return Consumer<TranslationService>(
      builder: (context, translation, child) {
        return MaterialApp(
          title: 'FirstAid Loum',
          debugShowCheckedModeBanner: false,
          
          // Thème identique à ton code
          theme: ThemeData(
            primaryColor: const Color(0xFF0056b3),
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0056b3),
              primary: const Color(0xFF0056b3),
              secondary: const Color(0xFF28a745),
            ),
            useMaterial3: true,
          ),

          // Gestion des Routes (Mise à jour avec Chat)
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/intro': (context) => IntroPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/home': (context) => const HomePage(),
            '/emergency': (context) => const EmergencyPage(),
            '/firstaid_steps': (context) => const FirstAidStepsPage(),
            '/profile': (context) => ProfilePage(),
            '/chat': (context) => ChatPage(), // Route pour la Chatbox
            '/carnet': (context) => CarnetMedicalPage(
              uid: FirebaseAuth.instance.currentUser?.uid ?? '',
            ),
          },
        );
      },
    );
  }
}