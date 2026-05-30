import 'package:flutter/material.dart';
import 'package:memory_weave/screens/Home.dart';
import 'package:memory_weave/screens/MemoriesScreen.dart';
import 'package:memory_weave/screens/ProfileScreen.dart';
import 'package:memory_weave/screens/TimelineScreen.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/HomeHeader.dart';
import 'package:memory_weave/widgets/MyNav.dart';

class Mainscreeen extends StatefulWidget {
  const Mainscreeen({super.key});

  @override
  State<Mainscreeen> createState() => _MainscreeenState();
}

class _MainscreeenState extends State<Mainscreeen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late List<Widget> screens;
  final PageController pageController = PageController();
  late int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
    screens = [
      HomeScreen(animation: animationController),
      Timelinescreen(animation: animationController),
      const Memoriesscreen(),
      const Profilescreen(),
    ];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // مثلا او الهيدر  Gnav هنا بقا بحط الحاجة اللي انا عايزها تفضل ثابتة في الصفحات كلها زي ال
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HomeHeader(),
      ),
      // هنا بقا هرجع في البودي البودي بتاع الصفحة اللي الانديكس واقف عليها
      body: PageView(
        controller: pageController,
        children: screens,
        onPageChanged: (val) {
          setState(() {
            currentIndex = val;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: AppColors.primaryBlue,
        onPressed: () {
          Navigator.pushNamed(context, "AddScreen");
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 15, left: 15),
        child: Mynav(
          currentIndex: currentIndex,
          onTabChange: (val) {
            setState(() {
              currentIndex = val;
            });
            pageController.jumpToPage(val);
          },
        ),
      ),
    );
  }
}
