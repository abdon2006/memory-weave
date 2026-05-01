import 'package:flutter/material.dart';
import 'package:memory_weave/Authentication/signup.dart';
import 'package:memory_weave/models/onboardingModel.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/Navigator_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // بنعمل انستانس من الكلاس المودل اللى عملناه عشان نستخدمه بعد كده
  final OnboardingModel model = OnboardingModel();
  int currentindex = 0;
  // بنعمل متغير عشان نشيك لو الصفحة دي اخر صفحة ولا لا
  bool get isLast => currentindex == 2;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
              bottom: 20,
              right: 20,
              left: 20,
            ),
            child: Row(
              children: [
                Spacer(),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minWidth: 60,
                  height: 30,
                  onPressed: () async {
                    if (currentindex != 2) {
                      pageController.animateToPage(
                        2,
                        curve: Curves.easeInOutCubic,
                        duration: Duration(milliseconds: 800),
                      );
                    } else {
                      // قبل ما ننتقل للصفحة اللي بعدها سجل عندك اني شوفتها
                      //Auth Wrapper عشان هنعوزها عشان التشيك في ال
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("seen_onboarding", true);
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        await navigatorTransition(const Signup()),
                      );
                    }
                  },
                  color: Colors.white,
                  child: Text(isLast ? "Let's Go !" : "Skip"),
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  // كل ما نقلب الصفحة المتغير تاعي بياخد رقم الصفحة
                  currentindex = index;
                });
              },
              controller: pageController,
              itemCount: 3,
              itemBuilder: (context, i) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        // عشان تبقي ثابتة علي اي شاشة
                        child: AspectRatio(
                          aspectRatio: 0.8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),

                            // بقي عالصورة بس container مهم جدا عشان الضل ميبقاش علي حواف ال
                            // clipper من ال Border readius وهنا خلينا الصوةر تاخد
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                model.images[i],
                                fit: BoxFit.cover,
                                frameBuilder: (context, child, frame, _) {
                                  if (frame == null) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(color: Colors.white),
                                    );
                                  }
                                  return child;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        model.headtext[i],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        model.subtext[i],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 90.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: CustomizableEffect(
                    dotDecoration: DotDecoration(
                      width: 10,
                      height: 10,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    activeDotDecoration: DotDecoration(
                      width: 10,
                      height: 10,
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: 100,
                  height: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () async {
                    if (isLast) {
                      // قبل ما ننتقل للصفحة اللي بعدها سجل عندك اني شوفتها
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("seen_onboarding", true);
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        await navigatorTransition(const Signup()),
                      );
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryBlue,
                  child: Text(
                    isLast ? "Get Started" : "Next",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Memory Weave",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Icon(
                    Icons.copyright_outlined,
                    color: Colors.grey,
                    size: 10,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "2026",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
