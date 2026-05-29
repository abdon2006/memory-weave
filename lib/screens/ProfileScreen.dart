import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_weave/Sqldb/sqldb.dart';
import 'package:memory_weave/data/timeline_data.dart';
import 'package:memory_weave/providers/Auth_provider.dart';
import 'package:memory_weave/screens/TimelineScreen.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/showEditNameDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_weave/widgets/HandleSetting.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen>
    with AutomaticKeepAliveClientMixin {
  @override
  // ده فايدته يحمي الصفحة انها تتشال ويفضل محافظ عليها
  bool get wantKeepAlive => true;

  //  برضو هنا نفس الكلام اللي عملناه في صفحة الاصافة نفس الفانكشن عشان تضيفلي الصورة
  File? selectedImage;
  Sqldb sqldb = Sqldb();
  int memoriesCount = 0;
  int timelineCount = 0;
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // دي بتجبلي الداتا بتاعة اليوزر ده من الفايرستور
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchData();
    });
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    // Table  اول حاجة بجيب كل الداتا من ال
    List<Map> response = await sqldb.select("memories");
    // عشان مهما قفلت وفتحت الصورة تفضل محفوظة SharedPreference هنا متغير لل
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString("profile_pic");
    setState(() {
      // عشان اطبع رقمها علي صفحة البروفايل Tableبعد كل الداا اللي في ال
      memoriesCount = response.length;
      // Table ونفس الكلام هنا بطبع كله بقا التايم لاين وال
      timelineCount = allMemories.length;
      if (savedImagePath != null) {
        selectedImage = File(savedImagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    String jobTitle = authProvider.userData["job"] ?? "";
    String name = authProvider.userData["username"] ?? "User";
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Stack(
              alignment: AlignmentGeometry.bottomRight,
              children: [
                // images لو انا اصلا مخترتش صورة قبل كده خلاص هيظهر صورة جاهزة عندي في ال
                selectedImage == null
                    ? CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("images/user.png"),
                      )
                    // لو انا كنت مختار قبل كده خلاص انا كده كده حفظتها بالشير بريفيرينس فهيظهرها بقا
                    : CircleAvatar(
                        radius: 70,
                        backgroundImage: FileImage(selectedImage!),
                      ),
                InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.5),
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue,
                    ),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 50),
                Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(jobTitle, textAlign: TextAlign.center),
                  ],
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    showEditNameDialog(context, name, jobTitle);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.5),
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue,
                    ),
                    child: Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "$memoriesCount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "Memories",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "$timelineCount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "Timelines",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$memoriesCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Collaborations",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("images/person 1.jpg"),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-10, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage("images/person 2.jpg"),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-20, 0),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "+5",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
            child: Text(
              "Setting & Preference",
              style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () => handleSetting(context, i),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        profileCardIcons[i],
                        color: AppColors.primaryBlue,
                      ),
                      title: Text(profileText[i]),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Consumer<AuthProvider>(
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 50.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        CherryToast.info(
                          title: const Text("GoodBye"),
                          description: const Text("Come Back Again"),
                          animationType: AnimationType.fromTop,
                        ).show(context);
                        await Future.delayed(Duration(seconds: 1));
                        await value.signout();
                        if (!context.mounted) return;
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.exit_to_app_rounded, color: Colors.red),
                        SizedBox(width: 5),
                        Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      // عشان لما اققفل وافتح الصورة تفضل موجودة SharedPreferenceهنا بقا بعمل ال
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_pic", image.path);
      await Future.delayed(Duration(seconds: 1));
      CherryToast.success(
        title: const Text("Success"),
        description: const Text("The New Photo Had Been Applied"),
        animationType: AnimationType.fromTop,
      ).show(context);
      print(
        "=================== صورة البروفايل اتحفظت بنجاح =======================",
      );
    }
  }
}
