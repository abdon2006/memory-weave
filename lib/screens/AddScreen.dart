import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/Sqldb/sqldb.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/AddHeader.dart';
import 'package:memory_weave/widgets/AddPhoto.dart';
import 'package:memory_weave/widgets/DatePicker.dart';
import 'package:memory_weave/widgets/mytextform.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  // sqldb بعمل انستانس من ال
  Sqldb sqldb = Sqldb();

  final addController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate;
  final narativeController = TextEditingController();
  // ده متغير عشان نحفظ فيه المسار بتاع الصورة اللي هيختارها اليوزر
  File? selectedImage;

  @override
  void dispose() {
    addController.dispose();
    dateController.dispose();
    narativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Addheader(),
            Addphoto(add: pickImage, selectedImage: selectedImage),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MyTextForm(
                  isStory: false,
                  color: Colors.white,
                  controller: addController,
                  hint: "Add Your Memory Title",
                  head: "Memory Title",
                  isPass: false,
                  validator: (val) => null,
                ),
              ),
            ),
            Datepicker(
              dateController: dateController,
              selected_date: selectedDate,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: MyTextForm(
                isStory: true,
                color: Colors.white,
                controller: narativeController,
                hint: "Tell The Story Behif Thid Moment",
                head: "THE NARRATIVE (CAPTION)",
                isPass: false,
                validator: (val) => null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                height: 50,
                color: AppColors.primaryBlue,
                onPressed: () async {
                  if (addController.text.isNotEmpty && selectedImage != null) {
                    // عشان نضيف بيانات الميموري insertهنستعمل هنا دالة ال
                    int respnse = await sqldb.insert("memories", {
                      "title": addController.text,
                      "date": dateController.text,
                      "description": narativeController.text,
                      "image": selectedImage!.path,
                    });
                    print(
                      "======================= Memory Saved in SQLite! ID: $respnse ====================== ",
                    );
                    if (!context.mounted) return;
                    CherryToast.success(
                      title: const Text("Success"),
                      description: const Text(
                        """Your Memory Had Published Succssfuly 
You can Check it at the timeline page""",
                      ),
                      animationType: AnimationType.fromTop,
                    ).show(context);
                    await Future.delayed(const Duration(milliseconds: 1500));
                    Navigator.pushReplacementNamed(context, "MainScreen");
                  } else {
                    CherryToast.warning(
                      title: const Text("warning"),
                      description: const Text(
                        "The memory Must Hava A title And image",
                      ),
                      animationType: AnimationType.fromTop,
                    ).show(context);
                  }
                },
                textColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 5),
                    Text("SaveMemory"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Your Memory Will be Woven Into The Digital Curator Timeline",
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    // بعمل انستانس من الكلاس اللي مسئولة عن التقاط الصور
    final ImagePicker picker = ImagePicker();
    // هنا بنقول للاداة افتحي المعرض وهاتي الصورة اللي اليوزر هيختارها
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //لو اليوز اختار صورة خلاص نحدث الواجهة و نحط مسار الصور ةفي المتغير بتاعنا
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }
}
