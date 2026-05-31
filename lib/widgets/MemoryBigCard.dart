import 'package:flutter/material.dart';
import 'package:memory_weave/models/memory_model.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:shimmer/shimmer.dart';

class Memorybigcard extends StatelessWidget {
  final MemoryItem item;
  const Memorybigcard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
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
                : Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          child: Image.asset(
                            item.image,
                            fit: BoxFit.cover,
                            frameBuilder:
                                (
                                  context,
                                  child,
                                  frame,
                                  wasSynchronouslyLoaded,
                                ) {
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
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 15,
                        child: Badge(
                          child: Container(
                            height: 25,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.burgandy,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    " ${item.badge} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              textAlign: TextAlign.center,
              item.title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Text(textAlign: TextAlign.center, item.date),
        ],
      ),
    );
  }
}
