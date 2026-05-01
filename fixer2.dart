import 'dart:io';

void main() async {
  var f = File('lib/Authentication/login.dart');
  var b = await f.readAsString();
  b = b.replaceAll('is_pass:', 'isPass:');
  await f.writeAsString(b);
  
  f = File('lib/Authentication/signup.dart');
  b = await f.readAsString();
  b = b.replaceAll('is_pass:', 'isPass:');
  await f.writeAsString(b);
  
  f = File('lib/providers/auth_provider.dart');
  b = await f.readAsString();
  b = b.replaceAll('debugPrint(e);', 'debugPrint(e.toString());');
  await f.writeAsString(b);
}
