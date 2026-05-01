import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/Authentication/login.dart';
import 'package:memory_weave/MainScreeen.dart';
import 'package:memory_weave/screens/onboarding_screen.dart';
import 'package:memory_weave/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // المتغير ده هو اللي هيقولنا: هل المستخدم شاف صفحات الـ Onboarding ولا لأ؟
  // خليناه bool? (يعني يقبل null) عشان نعرف هو لسه بيقرأ من الجهاز ولا خلص
  bool? seenOnboarding;

  @override
  void initState() {
    // أول ما الودجت تتشغل، بننادي على الفانكشن اللي بتفحص الـ Onboarding
    checkOnboarding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (seenOnboarding == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // 2. الفحص التاني: لو خلصنا قراءة وطلع إنه لسه مشافش الـ Onboarding (false)
    // بنوديه فوراً لصفحة الـ OnboardingScreen
    if (seenOnboarding == false) return OnboardingScreen();
    // خلاص يبقي ساعتها بقا نبدا نشوف هنوديه علي فين علي حسب هو مسجل دخول قبل كده ولا لا onBoarding لو عملنا تشيك وطلع انه شاف ال
    return StreamBuilder<User?>(
      // أول ما المستخدم يسجل دخول أو خروج، الـ Stream ده بيعرفنا فوراً
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // لو الـ Stream لسه بيحمل بياناته من السيرفر (مرحلة الـ Waiting)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        // MainScreen لو طلع مسجل دخول قبل كده هنوديه علي صفحة ال
        if (snapshot.hasData) {
          return Mainscreeen();
        }
        // عشان يسجل دخو Login لو وصل هنا معناه ان احنا ملقيناش داتا لليوزر ده فهنوديه بقا صفحة ال
        return Login();
      },
    );
  }

  // دي الفانكشن اللي بتفتح مخزن الجهاز (SharedPreferences) وتشوف القيمة متخزنة ولا لأ
  Future<void> checkOnboarding() async {
    // عشان لو كنا شوفناها خلاص مش هنشوفها تاني OnBoarding بنشووف بقا المتغير اللي حطناله قيمة في ال
    final prefs = await SharedPreferences.getInstance();
    // عشان لما يتح اليوزر يفضل مكمل  false لاي سبب معناه ان مثلا طلعت مالتطبيق قبل ما اكمل لاخر الصفحة ففي الحلة دي كمان اعتبره  nullلو بقت
    final seen = prefs.getBool("seen_onboarding") ?? false;
    // build ويدي المتغير اللي عملناه القيمة بتاعة الرؤية عشان نعمل بيها تشيك في ال  build نعمل بقا تحديث عشان يعيد بناء ال
    setState(() {
      seenOnboarding = seen;
    });
  }
}
