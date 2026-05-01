import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:shimmer/shimmer.dart';

class Addphoto extends StatefulWidget {
  final dynamic add;
  final File? selectedImage;
  const Addphoto({super.key, required this.add, required this.selectedImage});

  @override
  State<Addphoto> createState() => _AddphotoState();
}

class _AddphotoState extends State<Addphoto> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: widget.selectedImage == null
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                DottedBorder(
                  options: RectDottedBorderOptions(
                    color: Colors.grey,
                    dashPattern: [10, 5],
                    strokeWidth: 1.5,
                  ),
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () async {
                              await widget.add();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryBlue.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.photo_camera_rounded,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Upload photo or video",
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: -20,
                  right: -5,
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.burgandy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "FORMAT : JPG , PNG , MOV",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: widget.add,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.file(
                  widget.selectedImage!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                            height: 300,
                            width: double.infinity,
                          ),
                        );
                      },
                ),
              ),
            ),
    );
  }
}
