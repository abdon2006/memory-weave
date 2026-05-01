import 'package:flutter/material.dart';
import 'package:memory_weave/Sqldb/sqldb.dart';
import 'package:memory_weave/data/timeline_data.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/PulsingDot.dart';
import 'package:memory_weave/widgets/TimeLineScreenCard.dart';
import 'package:timeline_tile/timeline_tile.dart';

// sqfliteهنا هنعمل ليست كبيرة هنشيل في ها الاتنين ليست بتاعة الداتا الوهمية وبتاعة ال
List<Map> allMemories = [];

class Timelinescreen extends StatefulWidget {
  const Timelinescreen({super.key});

  @override
  State<Timelinescreen> createState() => _TimelinescreenState();
}

class _TimelinescreenState extends State<Timelinescreen> {
  Sqldb sqldb = Sqldb();
  bool is_loading = true;

  Future<void> readData() async {
    // اللي انا عملتها  Table اول ما الصفحة تتبني بنجيب كل الداتا بتاعتي اللي في ال
    List<Map> sqlData = await sqldb.select("memories");
    setState(() {
      // هنا بقا بنعمل عملية الدمج عشان الاتنين ليست يبقو ليست واحدة كبيرة نعرضها بعد كده
      allMemories = [...timelineScreenData, ...sqlData];
      is_loading = false;
    });
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return is_loading
        ? CircularProgressIndicator()
        : allMemories.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.satellite_alt_rounded,
                  color: AppColors.primaryBlue,
                  size: 30,
                ),
                SizedBox(height: 10),
                Text(
                  "There Is No Timeline Memories In This Moment",
                  style: TextStyle(color: AppColors.primaryBlue),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: allMemories.length,
            itemBuilder: (context, i) {
              return Dismissible(
                key: Key(
                  // iيبقا هناخد ال null لو الاتنين  titleلو وهمية اديله ال id عشان نعمل تشيك لو في الداتاالحقيقية اديله
                  allMemories[i]["id"]?.toString() ??
                      allMemories[i]["title"] ??
                      i.toString(),
                ),

                onDismissed: (direction) async {
                  var deletedItem = allMemories[i];
                  // يبقي لعنصر ده جاي من ال Table
                  if (deletedItem.containsKey("id")) {
                    int memoryId = deletedItem["id"];
                    // ده  id عند ال table بديله الامر عشان يحذف من ال
                    await sqldb.delete("memories", "id = $memoryId");
                    print(
                      "========== مسحنا الذكري رقم $memoryId من الداتا الحقيقية ==============",
                    );
                    await sqldb.select("memories");
                  } else {
                    // يبقي ده تبع الداتا الوهمية خلاص متعملش حاجة هنحذفه اهو في البلوك اللي جاي
                    print(
                      "============ تم حذف الذكري اللي في الداتا الوهمية ${allMemories[i]["title"]} =================",
                    );
                  }
                  // بس خلاص نحذف من الليست بتاعتنا العادية
                  setState(() {
                    allMemories.removeAt(i);
                    print(allMemories);
                  });
                },

                background: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete_sweep_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: TimelineTile(
                    // هيبقي المفروض يبدا او ينتهي هنا  indicator شرطين مهمين اوي عشان اعرف هل دي اول صورة ولا لا او اخر صورة عشان اعرف ساعتها ال
                    isFirst: i == 0,
                    isLast: i == (allMemories.length - 1),
                    endChild: Timelinescreencard(memoryData: allMemories[i]),
                    axis: TimelineAxis.vertical,
                    indicatorStyle: IndicatorStyle(
                      color: AppColors.primaryBlue,
                      indicator: PulsingDot(color: AppColors.primaryBlue),
                    ),
                    alignment: TimelineAlign.start,

                    afterLineStyle: LineStyle(
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    beforeLineStyle: LineStyle(
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
