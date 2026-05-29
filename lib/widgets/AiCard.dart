import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/PulsingDot.dart';

class AiCard extends StatelessWidget {
  final String headtext;
  final IconData icon;
  final String bigtext;
  final List<String> description;
  final String buttontext;
  final Animation<double> animation;

  const AiCard({
    super.key,
    required this.headtext,
    required this.icon,
    required this.bigtext,
    required this.description,
    required this.buttontext,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: AppColors.burgandy, offset: Offset(-5, 0)),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 30,
              top: 30,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 188, 202),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Icon(icon, color: Colors.white)),
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Text(
                headtext,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 120,
              left: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PulsingDot(color: AppColors.burgandy, animation: animation),
                  SizedBox(width: 10),
                  Text(
                    bigtext,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: AppColors.burgandy,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 160,
              left: 30,
              right: 30,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: description[0]),
                    TextSpan(
                      text: description[1],
                      style: TextStyle(
                        color: AppColors.burgandy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: description[2]),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {},
                color: AppColors.burgandy,
                textColor: Colors.white,
                child: Text(
                  buttontext,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
