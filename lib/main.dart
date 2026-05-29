import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_weave/Authentication/login.dart';
import 'package:memory_weave/Authentication/signup.dart';
import 'package:memory_weave/MainScreeen.dart';
import 'package:memory_weave/providers/Auth_provider.dart';
import 'package:memory_weave/screens/AddScreen.dart';
import 'package:memory_weave/screens/MemoriesScreen.dart';
import 'package:memory_weave/screens/ProfileScreen.dart';
import 'package:memory_weave/screens/onboarding_screen.dart';
import 'package:memory_weave/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:memory_weave/screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // هشان يسمع التطبيق كله ليه changeNotifierProvider هنا بنعمل
    ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme),
      ),
      home: SplashScreen(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "onboarding": (context) => OnboardingScreen(),
        "AuthWrapper": (context) => AuthWrapper(),
        "MainScreen": (context) => Mainscreeen(),
        "Memories": (context) => Memoriesscreen(),
        "Profile": (context) => Profilescreen(),
        "AddScreen": (context) => Addscreen(),
      },
    );
  }
}
