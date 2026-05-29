import 'package:flutter/material.dart';
import 'package:memory_weave/data/timeline_data.dart';
import 'package:memory_weave/models/memory_model.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/buildItems.dart';
import 'package:memory_weave/widgets/mytextform.dart';

class Memoriesscreen extends StatefulWidget {
  const Memoriesscreen({super.key});

  @override
  State<Memoriesscreen> createState() => _MemoriesscreenState();
}

class _MemoriesscreenState extends State<Memoriesscreen>
    with AutomaticKeepAliveClientMixin {
  @override
  // ده فايدته يحمي الصفحة انها تتشال ويفضل محافظ عليها
  bool get wantKeepAlive => true;
  // ده متغير عشان يشيل ال قسم اللي انا مختاره حاليا

  MemoryType? selectedFilter;

  final searchcontroller = TextEditingController();

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // اول مالصفحة تشتغل بحط كل الميموريز في الليست دي
    //بياخد نسخة من الداتا الأصلية (memoriesData) ويحطها في متغير العرض (displayedMemories).
    displayedMemories = List.from(memoriesData);
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
            Column(children: buildItems()),
          ],
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
          displayedMemories = List.from(memoriesData);
        } else {
          displayedMemories = memoriesData.where((item) {
            return item.title.toLowerCase().contains(searchFilter);
          }).toList();
        }
      });
    } else {
      // بقي اختار قسم معين فهعدي بقا علي الداتا الاصلي وافلتر علي حسب النوع ولو نفس النوع هضيفها ليا null لو مش
      //text form وهنا بقا صفنا حاجة تانية خالص هو اني  كمان اعمل فلتر بال تيكست اللي موجود في ال
      setState(() {
        displayedMemories = memoriesData.where((item) {
          bool matchesType = (item.type == type);
          bool matchesText =
              (searchFilter.isEmpty ||
              item.title.toLowerCase().contains(searchFilter));
          return matchesText && matchesType;
        }).toList();
      });
    }
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
}
