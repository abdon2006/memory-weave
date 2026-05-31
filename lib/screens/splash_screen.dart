import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void next() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    // كنا بنعاني من مشكلة ان الترانسيشن مش بيبان وبيقطع وده بسبب ان في صور كتير بتحمل وحجمها كبير
    // كان بيعلق فعشان كده ضفنا السطور دي اللي هو اتاكد من تحميل كل الصور قبل ما تروح onboarding وهو بينقل لل
    BuildContext ctx = context;
    await Future.wait([
      precacheImage(const AssetImage("images/on1.jpg"), ctx),
      precacheImage(const AssetImage("images/on2.jpg"), ctx),
      precacheImage(const AssetImage("images/on33.jpg"), ctx),
    ]);
    if (!mounted) return;
    Navigator.pushReplacementNamed(ctx, "AuthWrapper");
  }

  @override
  void initState() {
    next();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBlue,
              const Color.fromARGB(255, 101, 145, 255),
            ],
          ),
        ),
        child: Center(
          //  Animation دي اللي بتعمل ال
          child: TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 0.9, // يبدأ بحجم 90%
              end: 1.05, // ويكبر تدريجياً لـ 105%
            ),
            duration: const Duration(seconds: 5), // نفس مدة الانتظار للـ splash
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/icon.png"),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Text(
                      "Memory Weave",
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Weave Your Life's Story.",
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
