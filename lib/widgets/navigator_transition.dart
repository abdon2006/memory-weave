import 'package:flutter/material.dart';

Future<PageRouteBuilder<dynamic>> navigatorTransition(Widget screen) async {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return screen;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1, 0);
      var end = Offset.zero;
      var curve = Curves.easeInOutCubic;
      // ده عشان يدمج البداية والنهاية وكده وبياخد بقا الابعاد اللي عملتها
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      // اللي عملناه وبياخده عشان ينفذه tween ده بياخد ال
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: Duration(milliseconds: 1200), // زودناها عشان تبقا واضحة
  );
}
