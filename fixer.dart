import 'dart:io';

void main() async {
  
  // 1. splash_screen.dart
  var f = File('lib/screens/splash_screen.dart');
  var b = await f.readAsString();
  b = b.replaceAll('Navigator_transition(', 'navigatorTransition(');
  b = b.replaceAll('if (!mounted) return;', 'if (!context.mounted) return;');
  await f.writeAsString(b);

  // 2. onboarding_screen.dart
  f = File('lib/screens/onboarding_screen.dart');
  b = await f.readAsString();
  b = b.replaceAll('if (!mounted) return;', 'if (!context.mounted) return;');
  await f.writeAsString(b);

  // 3. home.dart
  f = File('lib/screens/home.dart');
  b = await f.readAsString();
  b = b.replaceAll('if (!mounted) return;', 'if (!context.mounted) return;');
  await f.writeAsString(b);

  // 4. auth_wrapper.dart
  f = File('lib/widgets/auth_wrapper.dart');
  b = await f.readAsString();
  b = b.replaceAll('seen_onboarding', 'seenOnboarding');
  await f.writeAsString(b);

  // 5. mycustombutton.dart
  f = File('lib/widgets/mycustombutton.dart');
  b = await f.readAsString();
  b = b.replaceAll('mycustomButton', 'MyCustomButton');
  b = b.replaceAll('final onpressed;', 'final void Function()? onpressed;');
  await f.writeAsString(b);

  // 6. mytextform.dart
  f = File('lib/widgets/mytextform.dart');
  b = await f.readAsString();
  b = b.replaceAll('is_pass', 'isPass');
  b = b.replaceAll('is_hidden', 'isHidden');
  await f.writeAsString(b);
  
  // 7. login.dart & signup.dart
  f = File('lib/Authentication/login.dart');
  b = await f.readAsString();
  b = b.replaceAll('MyCustomButton', 'MyCustomButton'); // just trigger format if needed
  b = b.replaceAll('mycustomButton', 'MyCustomButton');
  await f.writeAsString(b);
  
  f = File('lib/Authentication/signup.dart');
  b = await f.readAsString();
  b = b.replaceAll('mycustomButton', 'MyCustomButton');
  await f.writeAsString(b);
  
  // auth_provider
  f = File('lib/providers/auth_provider.dart');
  b = await f.readAsString();
  b = b.replaceAll('print(', 'debugPrint(');
  await f.writeAsString(b);
  
}
