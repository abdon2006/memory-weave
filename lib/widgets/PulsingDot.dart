import 'package:flutter/material.dart';

class PulsingDot extends StatelessWidget {
  final Color color;
  final Animation<double> animation;
  const PulsingDot({super.key, required this.color, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. الدائرة اللي بتكبر وتختفي (الصدى)
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              // بتكبر من حجمها الطبيعي لحد 3 أضعاف
              scale: 1.0 + (animation.value * 3),
              child: Opacity(
                // الشفافية بتقل تدريجياً لحد ما تختفي
                opacity: 1.0 - animation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.5), // لون الصدى أخف شوية
                  ),
                ),
              ),
            );
          },
        ),
        // 2. النقطة الأساسية الثابتة في النص
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ],
    );
  }
}
