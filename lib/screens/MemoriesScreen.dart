import 'package:flutter/material.dart';
import 'package:memory_weave/data/timeline_data.dart';
import 'package:memory_weave/models/memory_model.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/MemoryBigCard.dart';
import 'package:memory_weave/widgets/MemorySmallCard.dart';
import 'package:memory_weave/widgets/mytextform.dart';

class Memoriesscreen extends StatefulWidget {
  const Memoriesscreen({super.key});

  @override
  State<Memoriesscreen> createState() => _MemoriesscreenState();
}

class _MemoriesscreenState extends State<Memoriesscreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  MemoryType? selectedFilter;
  List<List<MemoryItem>> rows = [];
  final searchcontroller = TextEditingController();

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    buildRows(memoriesData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MyTextForm(
                  isStory: false,
                  controller: searchcontroller,
                  hint: "search Memory",
                  head: "",
                  icon: Icons.search,
                  isPass: false,
                  validator: (val) => null,
                  color: Colors.white,
                  onchanged: (val) {
                    filterMemory(selectedFilter);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    filterChip("All", null),
                    SizedBox(width: 10),
                    filterChip("Photos", MemoryType.photo),
                    SizedBox(width: 10),
                    filterChip("Voice", MemoryType.voice),
                    SizedBox(width: 10),
                    filterChip("Stories", MemoryType.story),
                    SizedBox(width: 10),
                    filterChip("Notes", MemoryType.note),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: (rows.isEmpty)
                  ? SizedBox(
                      width: double.infinity,
                      height: 600,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty_rounded,
                              color: Colors.blue,
                              size: 40,
                            ),
                            SizedBox(height: 5),
                            Text("""
There Is No Notes With
    That Specification"""),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rows.length,
                      itemBuilder: (context, i) {
                        if (rows[i].length == 1) {
                          return Memorybigcard(item: rows[i][0]);
                        } else {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: SizedBox(
                                      height: 200,
                                      width: 180,
                                      child: Memorysmallcard(item: rows[i][0]),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: SizedBox(
                                      height: 200,
                                      width: 180,
                                      child: Memorysmallcard(item: rows[i][1]),
                                    ),
                                  ),
                                ],
                              ),
                              rows[i].length == 3
                                  ? Memorybigcard(item: rows[i][2])
                                  : SizedBox(),
                            ],
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterChip(String label, MemoryType? type) {
    bool isSelected = selectedFilter == type;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          filterMemory(type);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.decelerate,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? AppColors.primaryBlue
              : Colors.grey.withOpacity(0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // دي الدالة اللي بتعملي عملية الفلترة
  void filterMemory(MemoryType? type) {
    // السطر ده مهم او عشان اصلا القسم اللي انا مختاره يتحدث لونه
    selectedFilter = type;
    // بنحفظ اختارنا اي عشان لون الزرار
    String searchFilter = searchcontroller.text.toLowerCase();
    if (type == null) {
      // نرجعله كل الميموريز All عشان لما يدوس علي
      setState(() {
        if (searchFilter.isEmpty) {
          buildRows(memoriesData);
        } else {
          List<MemoryItem> filtered = memoriesData.where((item) {
            return item.title.toLowerCase().contains(searchFilter);
          }).toList();
          buildRows(filtered);
        }
      });
    } else {
      setState(() {
        List<MemoryItem> filtered = memoriesData.where((item) {
          bool matchesType = (item.type == type);
          bool matchesText =
              (searchFilter.isEmpty ||
              item.title.toLowerCase().contains(searchFilter));
          return matchesText && matchesType;
        }).toList();
        buildRows(filtered);
      });
    }
  }

  void buildRows(List<MemoryItem> data) {
    rows = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i].isFeatured) {
        rows.add([data[i]]);
      } else {
        final right = (i + 1 < data.length) ? data[i + 1] : null;
        if (right != null) {
          rows.add([data[i], right]);
          i++;
        } else {
          rows.add([data[i]]);
        }
      }
    }
  }
}
