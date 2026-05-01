import 'package:flutter/material.dart';

class PulsingDot extends StatefulWidget {
  final Color color;
  const PulsingDot({super.key, required this.color});

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // العداد اللي هيتحكم في سرعة النبضة (ثانيتين للنبضة الواحدة)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // repeat بتخليها تشتغل وتتعاد للأبد
  }

  @override
  void dispose() {
    _controller.dispose(); // مهم جداً عشان منع استهلاك الميموري
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. الدائرة اللي بتكبر وتختفي (الصدى)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              // بتكبر من حجمها الطبيعي لحد 3 أضعاف
              scale: 1.0 + (_controller.value * 3),
              child: Opacity(
                // الشفافية بتقل تدريجياً لحد ما تختفي
                opacity: 1.0 - _controller.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.5), // لون الصدى أخف شوية
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      ],
    );
  }
}
