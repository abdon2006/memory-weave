// ظهرت مشكلة ان عندي انا مقسمهم اتنتين كارد كبير وكارد صغير فهي الصفحة كانت متقسمة كارد كبير وبعديها
// builditems فيه اتنين كارد صغير فعملنا فانطشن عشان تهندل الحوارادخ الليهي  Row
import 'package:flutter/material.dart';
import 'package:memory_weave/data/timeline_data.dart';
import 'package:memory_weave/widgets/MemoryBigCard.dart';
import 'package:memory_weave/widgets/MemorySmallCard.dart';

List<Widget> buildItems() {
  List<Widget> widgets = [];
  int i = 0;
  while (i < displayedMemories.length) {
    if (displayedMemories[i].isFeatured) {
      widgets.add(Memorybigcard(item: displayedMemories[i]));
      i++;
    } else {
      final left = displayedMemories[i];
      //  null  بس العدد كله فردي قكان هيتبقي واحد واللي عاليمين كان هيعملي مشكلة فبس كل الفكرة انه خليته يقبل ال  Row السطر ده كده عشان مثلا لو جينا  نعمل
      final right = (i + 1 < displayedMemories.length)
          ? displayedMemories[i + 1]
          : null;
      widgets.add(
        SizedBox(
          height: 230,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SizedBox(
                  height: 200,
                  width: 180,
                  child: Memorysmallcard(item: left),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SizedBox(
                  height: 200,
                  width: 180,
                  child: right != null
                      ? Memorysmallcard(item: right)
                      : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      );
      i += right != null ? 2 : 1;
    }
  }
  return widgets;
}
