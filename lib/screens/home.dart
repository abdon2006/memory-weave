import 'package:flutter/material.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/data/timeline_data.dart';
import 'package:memory_weave/widgets/AiCard.dart';
import 'package:memory_weave/widgets/PulsingDot.dart';
import 'package:memory_weave/widgets/TimelineCard.dart';
import 'package:memory_weave/widgets/mytextform.dart';
import 'package:memory_weave/widgets/scroll_animator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchcontroller = TextEditingController();
  // دي الليست اللي هنشيل فيها لحظيا الداتا المتفلترة عشان لما حد يكتب في السيرش الداتا تتفلتر علي حسب اللي مكتوب
  List filterdTimeline = [];
  @override
  void initState() {
    // مبدايا الليست دي هتاخد كل الداتا
    filterdTimeline = List.from(timelineData);
    //يسمع دايما للدالة اللي بتعمل الفحص كل شوية عشان يحدث الهوم بنائا علي اللي في التيكست فيلد textEditingContoller هنخلي ال
    searchcontroller.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchcontroller.removeListener(_onSearchChanged);
    searchcontroller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchcontroller.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // لو التيكست فيلد فاضية  خلاص اظهر كل حاجة
        filterdTimeline = List.from(timelineData);
      } else {
        // لأو هو فعلا كاتب حاجة خلاص هنعدي علي الداتا الاصلية ونشوف مين من الداتا العنوانا بتاعه بيطاببق اللي اليوزر كاتبه في السيرش
        filterdTimeline = timelineData.where((item) {
          return item['title'].toString().toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: -9,
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: MyTextForm(
                  isStory: false,
                  controller: searchcontroller,
                  hint: "Search Through Your History",
                  head: "",
                  icon: Icons.search,
                  isPass: false,
                  validator: (_) {
                    return;
                  },
                  color: Colors.white,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 20),
              child: Row(
                children: [
                  PulsingDot(color: AppColors.primaryBlue),
                  SizedBox(width: 10),
                  Text(
                    textAlign: TextAlign.start,
                    "Active TimeLines",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "Memories");
                    },
                    child: Container(
                      height: 30,
                      width: 60,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                decoration: BoxDecoration(),
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),

                  itemCount: filterdTimeline.length,
                  itemBuilder: (context, i) {
                    return TimelineCard(index: i, data: filterdTimeline[i]);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Divider(color: AppColors.burgandy),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.query_stats_sharp,
                    color: AppColors.burgandy,
                    size: 25,
                  ),
                  SizedBox(width: 15),
                  Text(
                    textAlign: TextAlign.start,
                    "Ai Insights",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgandy,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 700,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ScrollAnimator(
                      child: AiCard(
                        headtext: "PATTERN FOUND",
                        icon: Icons.stacked_line_chart_rounded,
                        bigtext: "Family Reunion Likely",
                        description: [
                          "You've Uploaded 15 Photos With ",
                          " Sarah & David",
                          """ This Week. Would You Like To Add A Memory With Them
                    " gathering album " """,
                        ],
                        buttontext: "Curate Now",
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                    child: ScrollAnimator(
                      child: AiCard(
                        headtext: "MEMORY LANE",
                        icon: Icons.watch_later_outlined,
                        bigtext: "5 Years ago Today",
                        description: [
                          " \" TheGrandCanyonExpedetion \" Started Today In ",
                          "2019. ",
                          " Revist The Stories From Your First National Park Trip ",
                        ],
                        buttontext: "Explore Legacy",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
