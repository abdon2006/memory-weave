import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  //عملنا ماب عشان نجيب فيها كل بيانات ال عميل
  Map<String, dynamic> userData = {};
  User? user;
  bool isLoading = false;
  String? errorMessage;

  Future<void> initUser() async {
    user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> createUser(
    String email,
    String password,
    String username,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = credential.user;
      //  FireStore  واحطه في ال user الكود الجاي ده عشان اخد اسم ال
      // السطرين تلاتة دول انا خدت كل البيانات اللي دخلها اليوزر واللي سجل بيها حاليا وسجلتها عندي في الداتا بيز
      if (credential.user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid)
            .set({
              'uid': credential.user!.uid,
              'username': username,
              'email': email,
              'createdAt': DateTime.now(),
              "job": "",
            });
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "The Email You Entered is Already in use";
          break;
        default:
          errorMessage = "Undefined Error has happined { ${e.message}}";
      }
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Ther is No Account Registered With That Email";
          break;
        case 'wrong-password':
          errorMessage = "The Password is Incorrect";
        default:
          errorMessage = "Undefined Error has happined { ${e.message}}";
      }
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> signinWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // login لو قفل ومختارش حاجة يرجعو عادي لصفحة ال
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      user = userCredential.user;
      //     هنجيب بيانات اليوزر من جوجل ونحطها عالفاير بيز ونعملها جلب عشان نحطها في الهوم create user هنا هنعمل نفس اللي عملناه في دالة ال
      if (userCredential.user != null) {
        // هنا بنجيب بيانات المستخدم
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid);

        // هنا بنتاكد هلي اليوزر ده موجود قبل كده ولا اول مرة يسجل
        final docSnap = await docRef.get();
        // لو مش موجود يعني اول مرة يسجل ينفذ بق الباقي
        if (!docSnap.exists) {
          docRef.set({
            "uid": userCredential.user!.uid,
            "username": userCredential.user!.displayName ?? "Google User",
            "createdAt": DateTime.now(),
            "email": userCredential.user!.email,
            "job": "",
          });
        }
      }

      debugPrint("================= تم تسجيل لدخول بنجاح ================");
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      debugPrint(errorMessage);
    } catch (e) {
      errorMessage = 'حدث خطأ اثناء تسجيل الدخول بواسطة جوجل';
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signout() async {
    // بتسجل خروج عادي من الحساب الحالي
    await FirebaseAuth.instance.signOut();

    // Home هنا بقا انا بسجل خروج من حساب جوجل لو انا مسجل بيه عشان بعد كده لم ا اجي اسجل بيه يجبل يالنافذة اللي اختار منها بدلم ايوديني تلقائي عال
    await _googleSignIn.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "This email is not registered in our records";
          break;
        default:
          errorMessage = e.message;
      }
      notifyListeners();
    } catch (e) {
      errorMessage = "An unexpected error occurred";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    // واخزنها في الماب الفاضية اللي عملتها فوق Firestore بعد كده بجيب الداتا بتاعته من ال  user هنا انا اول حاجة بتاكد ان في
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> response =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get();
        if (response.exists && response.data() != null) {
          userData.clear();
          userData.addAll(response.data() as Map<String, dynamic>);
          print(userData);
          print("============= جبنا الداتا بنجاح ===========");
          notifyListeners();
        } else {
          // لو مفيش بيانات، نحط بيانات وهمية عشان التطبيق ميفضلش يحمل
          userData = {"username": "User", "job": ""};
          print(
            "============ الحساب ده ملوش بيانات في الفايرستور ============",
          );
          notifyListeners();
        }
      } catch (e) {
        print("=============== حصل خطأ في جلب البيانات : $e");
      }
    } else {
      print("===================== مفيش مستخدم مسجل دخول =================");
    }
  }

  // دالة مسئولة عن تعديل اسم اليوزر في صفحة البروفايل
  Future<void> updateUserDetails(String newName, String? job) async {
    try {
      final curruntUser = FirebaseAuth.instance.currentUser;
      // بنحدث الاسم في الفايربيز
      await FirebaseFirestore.instance
          .collection("users")
          .doc(curruntUser!.uid)
          .update({"username": newName, "job": job});
      // بنحدث الاسم في ال داتا بتاعت الابلكيشن
      userData["username"] = newName;
      userData["job"] = job;
      notifyListeners();
      print("============= name updated successfluly ===========");
    } catch (e) {
      print("===================== Error Updating Name $e ==================");
    }
  }
}
