import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';

class Addheader extends StatelessWidget {
  const Addheader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_rounded, color: AppColors.primaryBlue),
          ),
          SizedBox(width: 70),
          Text("Add a Memory", style: TextStyle(fontSize: 30)),
          Spacer(),
        ],
      ),
    );
  }
}
