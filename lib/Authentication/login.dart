import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:memory_weave/providers/Auth_provider.dart';
import 'package:memory_weave/themes/colors.dart';
import 'package:memory_weave/widgets/mycustombutton.dart';
import 'package:memory_weave/widgets/mytextform.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
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
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 2,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "step back into your digital legacy ✨",
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
                    MyTextForm(
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
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(val)) {
                          return 'Pleas Enter A Valid Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    MyTextForm(
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 20),
              child: Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      // اتاكد الاول ان في ايميل مكتوب عشان ابعت عليه اللينك
                      if (email.text.isEmpty) {
                        CherryToast.error(
                          title: Text("Error"),
                          description: Text(
                            "Please Enter Your Email To Send The reset Link",
                          ),
                          animationType: AnimationType.fromTop,
                        ).show(context);
                      } else {
                        // لأو كاتب ايميل خلاص ابعت عليه اللينك
                        await auth.resetPassword(email.text);
                        if (context.mounted) {
                          if (auth.errorMessage != null) {
                            CherryToast.error(
                              title: Text("Error"),
                              description: Text("${auth.errorMessage}"),
                              animationType: AnimationType.fromTop,
                            ).show(context);
                          } else {
                            CherryToast.success(
                              title: const Text("Success"),
                              description: const Text(
                                "The Reset Password Link Had Been Sent Successfuly",
                              ),
                              animationType: AnimationType.fromTop,
                            ).show(context);
                          }
                        }
                      }
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyCustomButton(
                // بنغير التيكست وقت التحميل
                text: auth.isLoading ? "Wait....." : "Login",
                // بنعطل الزرار وقت التحميل عشان يمنع كتر الطلبات
                onpressed: () async {
                  if (auth.isLoading) {
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    );
                  } else {
                    if (formstate.currentState!.validate()) {
                      await context.read<AuthProvider>().signIn(
                        email.text,
                        pass.text,
                      );
                      if (!context.mounted) return;
                      final authprovider = context.read<AuthProvider>();
                      if (authprovider.errorMessage != null) {
                        CherryToast.error(
                          title: Text("Error"),
                          description: Text(authprovider.errorMessage!),
                          animationType: AnimationType.fromTop,
                        ).show(context);
                      } else if (authprovider.user != null) {
                        CherryToast.success(
                          title: const Text("Success"),
                          description: const Text("""
Welcome Back In Your Account
We Have Missed You"""),
                          animationType: AnimationType.fromTop,
                        ).show(context);

                        await Future.delayed(Duration(seconds: 1));
                        if (context.mounted) {
                          Navigator.pushNamed(context, "MainScreen");
                        }
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
                      "OR SIGN IN WITH",
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Dont Have An Account ? "),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "signup");
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
