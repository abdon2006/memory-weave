// الفانكشن دي تقدر تحطها جوه ملف البروفايل أو في ملف لوحدها
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/providers/Auth_provider.dart';
import 'package:provider/provider.dart';

void showEditNameDialog(BuildContext originalContext, String name, String job) {
  final authprovider = originalContext.read<AuthProvider>();
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  nameController.text = name;
  jobController.text = job;

  // كنترولر عشان ناخد منه الاسم الجديد
  showDialog(
    context: originalContext,
    // الخاصية دي بتخلي الخلفية اللي ورا الـ Dialog عليها بلور (Blur) خفيف.. حركة روشة جداً!
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ), // حواف دائرية زي الديزاين بتاعك
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // عشان الـ Dialog ياخد مساحة المحتوى بس
            children: [
              Text(
                "Edit Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // حقل الإدخال
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter new name",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: jobController,
                decoration: InputDecoration(
                  hintText: "Enter Your Job",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(dialogContext), // زرار الإلغاء
                    child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) {
                        CherryToast.warning(
                          title: const Text("Warning"),
                          description: Text("Please Enter a username"),
                          animationType: AnimationType.fromTop,
                        ).show(dialogContext);
                        // add عشان انا هعرض علي صفحة ال  dialog context عملنا ال
                        return;
                        // و عملنا ريتيرن فاضي عشان خلاص يقف الفانكشمن هنا ميروحش يعمل تشيك عالباقي
                      }
                      await authprovider.updateUserDetails(
                        nameController.text,
                        jobController.text,
                      );
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                      await Future.delayed(Duration(milliseconds: 500));
                      if (originalContext.mounted) {
                        CherryToast.success(
                          title: const Text("Success"),
                          description: Text("""
Your new name : ${nameController.text} ,
Your New Job : ${jobController.text}"""),
                          animationType: AnimationType.fromTop,
                        ).show(originalContext);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // أو AppColors.primaryBlue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
