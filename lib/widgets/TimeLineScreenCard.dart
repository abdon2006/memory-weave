import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:shimmer/shimmer.dart';

class Timelinescreencard extends StatefulWidget {
  final Map memoryData;
  const Timelinescreencard({super.key, required this.memoryData});

  @override
  State<Timelinescreencard> createState() => _TimelinescreencardState();
}

class _TimelinescreencardState extends State<Timelinescreencard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20),
      child: SizedBox(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: buildImage(widget.memoryData["image"] ?? ""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                textAlign: TextAlign.center,
                "${widget.memoryData["title"] ?? widget.memoryData["headText"] ?? "Untitled Memory"}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              "${widget.memoryData["description"] ?? ""}",
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60),

                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryBlue,
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.start,
                    "${widget.memoryData["date"] ?? ""}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  // asst وباقي الداتا عندي كانت  image.file غصب عني لما برفع الصور ةوبضيفها للداتا بتبقي علي هيئة  add عملنا الفانكشن دي عشان لما عملت صفحة ال
  Widget buildImage(String imagePath) {
    if (imagePath.isEmpty) return Container(color: Colors.grey);

    if (imagePath.startsWith('images/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,

        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
              height: 200,
              width: double.infinity,
            ),
          );
        },
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,

        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
              height: 200,
              width: double.infinity,
            ),
          );
        },
      );
    }
  }
}
