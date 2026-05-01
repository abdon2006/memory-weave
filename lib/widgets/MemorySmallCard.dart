import 'package:flutter/material.dart';
import 'package:memory_weave/models/memory_model.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:shimmer/shimmer.dart';

class Memorysmallcard extends StatelessWidget {
  final MemoryItem item;
  const Memorysmallcard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: item.type == MemoryType.voice
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 120,
                      width: 180,
                      child: Icon(
                        Icons.voice_chat,
                        size: 70,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Icon(
                        Icons.keyboard_voice_rounded,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Image.asset(
                    item.image,
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
                              height: 120,
                              width: double.infinity,
                            ),
                          );
                        },
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 5),
          child: Text(
            textAlign: TextAlign.start,
            item.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        item.type == MemoryType.voice
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      textAlign: TextAlign.start,
                      "${item.duration} /",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      textAlign: TextAlign.start,
                      item.date,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  textAlign: TextAlign.start,
                  item.date,
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ],
    );
  }
}
