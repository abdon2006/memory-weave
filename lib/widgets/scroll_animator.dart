import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollAnimator extends StatefulWidget {
  final Widget child;
  const ScrollAnimator({super.key, required this.child});

  @override
  State<ScrollAnimator> createState() => _ScrollAnimatorState();
}

class _ScrollAnimatorState extends State<ScrollAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // مدة الأنيميشن نص ثانية
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // أنيميشن الشفافية (من 0 لـ 1)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // أنيميشن الحركة (من تحت لفوق شوية)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      // الـ key مهم عشان المكتبة تفرق بين الكروت
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        // info.visibleFraction دي بتجيب نسبة ظهور الكارت (من 0 لـ 1)
        if (info.visibleFraction > 0.15) {
          // لو الكارت ظهر منه 15%، شغل الأنيميشن
          _controller.forward();
        } else if (info.visibleFraction == 0) {
          // لو الكارت اختفى تماماً من الشاشة (لما تطلع لفوق)، اعكس الأنيميشن وارجع خفيه
          _controller.reverse();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: widget.child),
      ),
    );
  }
}
