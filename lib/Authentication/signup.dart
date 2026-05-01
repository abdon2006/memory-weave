import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/providers/Auth_provider.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/mycustombutton.dart';
import 'package:memory_weave/widgets/mytextform.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  final email = TextEditingController();
  final pass = TextEditingController();
  final username = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    username.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/icon.png"),
                    ),
                  ),
                  height: 200,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 2,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Make Your Entry To Your Own Weaves ✨",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formstate,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: MyTextForm(
                        isStory: false,
                        controller: username,
                        hint: 'Enter Your Username',
                        head: 'Username',
                        icon: Icons.person,
                        isPass: false,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please Enter Your Username";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: MyTextForm(
                        isStory: false,
                        controller: email,
                        hint: 'Enter Your Email',
                        head: 'Email',
                        icon: Icons.email_outlined,
                        isPass: false,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please Enter An Email";
                          }
                          // هنا دي عشان اتاكد مالصيغة بتاعت الايميل هل هي فعلا صيغة ايميل ولا اي كلام مكتوب
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(val)) {
                            return 'Pleas Enter A Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: MyTextForm(
                        isStory: false,
                        controller: pass,
                        hint: 'Enter Your Password',
                        head: 'Password',
                        icon: Icons.lock,
                        isPass: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          if (val.length < 6) {
                            return "The Password Cannot Be Less Than 6 Characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: MyTextForm(
                        isStory: false,
                        controller: confirm,
                        hint: 'Confirm Your Password',
                        head: 'Confirm Password',
                        icon: Icons.lock,
                        isPass: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Please Confirm Your Password";
                          }
                          if (val != pass.text) {
                            return "Password isn't Matched";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyCustomButton(
                // بنغير التيكست وقت التحميل
                text: auth.isLoading ? "Wait....." : "Sign Up",
                onpressed: () async {
                  // كلها عدي منها  validation  متنفذش اي تسجيل دخول الا لو الشروط بتاعت ال
                  if (formstate.currentState!.validate()) {
                    await context.read<AuthProvider>().createUser(
                      email.text,
                      pass.text,
                      username.text,
                    );
                    if (!context.mounted) return;
                    final authProvider = context.read<AuthProvider>();

                    if (authProvider.errorMessage != null) {
                      CherryToast.error(
                        title: Text("Error"),
                        description: Text("${authProvider.errorMessage}"),
                        animationType: AnimationType.fromTop,
                      ).show(context);
                    } else if (authProvider.user != null) {
                      CherryToast.success(
                        title: const Text("Success"),
                        description: const Text("Welcome In Your New Account"),
                        animationType: AnimationType.fromTop,
                      ).show(context);

                      await Future.delayed(Duration(seconds: 1));
                      // MainScreen لو خلاص عدي من  كل ده بنجاح يبقي وديه لصفحة ال
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "MainScreen",
                          (route) => false,
                        );
                      }
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Divider(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "OR SIGN UP WITH",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Divider(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: SizedBox(
                  height: 50,
                  child: auth.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            await context
                                .read<AuthProvider>()
                                .signinWithGoogle();

                            if (!context.mounted) return;
                            final authProvider = context.read<AuthProvider>();

                            if (context.mounted &&
                                authProvider.errorMessage != null) {
                              CherryToast.error(
                                title: Text("Error"),
                                description: Text(
                                  "${authProvider.errorMessage}",
                                ),
                                animationType: AnimationType.fromTop,
                              ).show(context);
                            } else if (context.mounted &&
                                authProvider.user != null) {
                              CherryToast.success(
                                title: const Text("Success"),
                                description: const Text(
                                  "Welcome In Your Google Account",
                                ),
                                animationType: AnimationType.fromTop,
                              ).show(context);

                              await Future.delayed(Duration(seconds: 1));
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "MainScreen",
                                  (route) => false,
                                );
                              }
                            }
                          },
                          child: Image.asset("images/google.png"),
                        ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Already Have An Account ? "),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "login");
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
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
