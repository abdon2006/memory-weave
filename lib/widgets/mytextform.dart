import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';

class MyTextForm extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String head;
  final IconData? icon;
  final bool isPass;
  final String? Function(String?)? validator;
  final dynamic color;
  final void Function(String)? onchanged;
  final bool isStory;

  const MyTextForm({
    super.key,
    required this.controller,
    required this.hint,
    required this.head,
    this.icon,
    required this.isPass,
    required this.validator,
    this.color,
    this.onchanged,
    required this.isStory,
  });

  @override
  State<StatefulWidget> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  bool isHidden = true; // الباسورد مخفي في البداية

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0),
          child: Text(
            textAlign: TextAlign.start,
            widget.head,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        TextFormField(
          maxLines: widget.isStory ? 5 : 1,
          onChanged: widget.onchanged,
          validator: widget.validator,
          obscureText: widget.isPass && isHidden,
          controller: widget.controller,

          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: widget.isStory
                  ? BorderSide.none
                  : BorderSide(color: AppColors.primaryBlue, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),

            fillColor: widget.color ?? Colors.grey[300],
            filled: true,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),

            hintText: widget.hint,
            hintStyle: widget.isStory
                ? TextStyle(color: Colors.grey[400], fontSize: 20)
                : TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

            prefixIcon: Icon(widget.icon, color: Colors.grey),

            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            suffixIcon: widget.isPass
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    icon: Icon(
                      isHidden ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.primaryBlue,
                    ),
                  )
                : null,
          ),
        ),
        // TextFormField(controller: pass),
      ],
    );
  }
}
