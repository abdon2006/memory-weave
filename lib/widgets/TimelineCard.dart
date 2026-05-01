import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TimelineCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  const TimelineCard({super.key, required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Image.asset(
                  "${data["image"]}",
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null)
                          return child;
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "${data["title"]}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: AssetImage("images/person 1.jpg"),
                ),
                Transform.translate(
                  offset: Offset(-10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage("images/person 2.jpg"),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(-20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage("images/person 4.jpg"),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(-40, 0),
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 199, 199),
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: data["extraCount"] > 0
                        ? CircleAvatar(
                            child: Center(
                              child: Text(
                                "+${data["extraCount"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
