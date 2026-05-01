import 'package:flutter/material.dart';
import 'package:memory_weave/widgets/mytextform.dart';

// ignore: must_be_immutable
class Datepicker extends StatefulWidget {
  final dateController;
  DateTime? selected_date;
  Datepicker({super.key, this.dateController, this.selected_date});

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: widget.selected_date ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (picked != null && picked != widget.selected_date) {
            setState(() {
              widget.selected_date = picked;
              widget.dateController.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            });
          }
        },
        child: AbsorbPointer(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: MyTextForm(
              isStory: false,
              color: Colors.white,
              controller: widget.dateController,
              hint: "Select Date",
              head: "Memory Date",
              isPass: false,
              icon: Icons.calendar_today,
              validator: (val) => null,
            ),
          ),
        ),
      ),
    );
  }
}
