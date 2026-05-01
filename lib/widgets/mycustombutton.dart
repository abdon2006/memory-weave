import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';

class MyCustomButton extends StatelessWidget {
  final String text;
  final void Function()? onpressed;

  const MyCustomButton({
    super.key,
    required this.text,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      height: 60,
      onPressed: onpressed,
      color: AppColors.primaryBlue,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
