import 'package:sqflite/sqflite.dart';
// استيراد مكتبة المسارات path لجلب عنوان المجلدات الصحيحة داخل نظام التشغيل
import 'package:path/path.dart';

// كلاس إدارة قاعدة البيانات يجمع كل الدوال لتسهيل التحكم فيها من كل التطبيق
class Sqldb {
  // متغير خاص يمثل نسخة قاعدة البيانات لمنع إنشاء أكثر من نسخة (نمط المُفرَد/Singleton)
  static Database? _db;

  // كل مهمته ان يتاكدلي ان الداتابيز دي متعملتش قبل كده عشان هي المفروض تتعمل مرة واحدة getter ده
  // بس لو اتعملت خلاص يرجعهالي لو متعملتش ينشئها و يرجعهالي
  Future<Database?> get db async {
    if (_db == null) {
      // بناء وبدء الداتابيز عبر هذه الدالة
      _db = await initialdb();
      return _db;
    } else {
      return _db;
    }
  }

  //  database دي اهم دالة دي اللي بتعملي كل حاجة وفيها كل الاوامر اللي بتبنيلي ال
  // (هذه دالة التهيئة الأساسية التي تتحكم في المسار وربط الجداول والأوامر)
  Future<Database> initialdb() async {
    // هنا بيرجع الباث مثلا ****/***/***/
    // (الوصول للمسار الخاص بحفظ قواعد البيانات داخل نظام تشغيل الهاتف الحالي)
    String databasepath = await getDatabasesPath();

    // هنا بيضيف بقا اسم الداتابيز الل احنا بنعملها في اخر الباث عشان ده يبقي الباث النهائي وكده ****/***/databasename
    // (دمج المسار الافتراضي مع اسم ملف الـ داتابيز بصيغة .db)
    String path = join(databasepath, "mydb.db");

    // SQL ده الامر اللي بيفتح الداتا بيز عشان كده بيدله الباث وبيشغل فانكشن اللي انا عاملها اللي برضو بنكتب فيها كود ال
    // مبنشتغلش غير مرة واحدة بس لما انشأ الداتابيز غير كده مبتشتغلش تاني  oncreate  في حاجة مهمة اوي ال
    // version مبتشتغلش غير لما نغير ال  onupgrade  وال
    Database mydb = await openDatabase(
      path,
      // دالة يتم تفعيلها لأول مرة فقط عند تكوين الجداول
      onCreate: _createdb,
      // رقم الإصدار لمعرفة ما تم تغييره للتهيئة لاحقا
      version: 1,
      // تُشغل عند تغيير رقم الإصدار مما يسهل تحديث العواميد بالجداول
      onUpgrade: _upgradedb,
    );
    // إرجاع الاتصال الشغال بشكل كامل للبرنامج
    return mydb;
  }

  // الدالة التي تعمل عند تحديث رقم إصدار قاعدة البيانات للمستخدم
  Future _upgradedb(Database mydb, int oldversion, int newversion) async {
    // طباعة للاختبار بأن التحديث تم
    print("================ onupgrade =================");
  }

  // اللي انا هكتبه SQL دي الفانكشن اللي بعملها عشان تنفذلي كود ال
  // (هنا نكتب نص الإنشاء الرئيسي بلغة SQL لتكوين جداول النظام وعواميده)
  Future<void> _createdb(Database db, int version) async {
    // تنفيذ كود نصي مباشر لبناء جدول
    await db.execute("""

  CREATE TABLE "memories" (

  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
  title TEXT NOT NULL ,
  date TEXT NOT NULL ,
  description TEXT NOT NULL ,
  image TEXT NOT NULL
  )
""");
    // عشان نتاكد ان الكود اتنفذ مظبوط
    // (طباعة لمعرفة أنه قد تم العمل بنجاح)
    print(
      "=============== MEMORIES DATABASE CREATED SUCCESSFULY ===============",
    );
  }

  // insert , update , delete , select  الاربع فانكشز دول هما اللي هيعملولي الاربع عمليات
  // response بتاخد الامر ال سيكوال كباراميتر وبتنفذ الكود وبترجعلي ال select  هنا مثلا الفانكشن بتاعة ال
  // (دالة تنفذ استعلام نصي يجلب بيانات من قاعدة البيانات مباشرة ويعيدها كلِست/قائمة)
  Future selectdata(String sql) async {
    // Database? mydb = await db; Null مش المتغير اللي عملناه فوق عشان لةو نادينا علي المتغير علي طول ممكن يبقي  getter هنا احنا بننادي علي ال
    // (تحضير استدعاء اتصال الـ db)
    Database? mydb = await db;
    // تخزين نتيجة التنفيذ النصي في أسلوب قائمة الخرائط أو (List of Maps)
    List<Map> response = await mydb!.rawQuery(sql);
    // تسليم النتيجة إلى دالة الاستدعاء في البرنامج
    return response;
  }

  // دالة لتنفيذ أمر مكتوب بالكامل لعمل إدراج بيانات في الجدول وتعيد رقم المُدْرَج
  Future insertdata(String sql) async {
    // الحصول على الاتصال بقاعدة البيانات
    Database? mydb = await db;
    // تنفيذ أمر الإدخال النصي
    int response = await mydb!.rawInsert(sql);
    // إعادة الـ ID أو مؤشر العملية
    return response;
  }

  // دالة لتحديث البيانات عبر كود استعلام SQL قوي بشكل نصي ويدوي
  Future updatedata(String sql) async {
    // التأكد من استدعاء الاتصال الحي
    Database? mydb = await db;
    // تشغيل الأمر لتعديل جزء من الجدول
    int response = await mydb!.rawUpdate(sql);
    // إرجاع النتيجة
    return response;
  }

  // دالة لتنفيذ عملية مسح البيانات باستعمال الكود النصي اليدوي
  Future deletedata(String sql) async {
    // التأكد من استدعاء الاتصال الحي
    Database? mydb = await db;
    // أمر إزالة بالصيغة المباشرة
    int response = await mydb!.rawDelete(sql);
    // إرجاع المتغير الدال على عدد ما تم مسحه
    return response;
  }

  // Database دي دالة عشان نحذف منها ال
  void deletedb() async {
    // الوصول لنفس مسار مجلد قواعد بيانات النظام الحالي
    String databasepath = await getDatabasesPath();
    // الحصول على المسار المدمج للملف المطلوب حذفه
    String path = join(databasepath, "mydb.db");
    // استدعاء الأمر الأصلي من فلاتر لمسح هذا الملف وبالتالي تدمير الداتابيز
    await deleteDatabase(path);
  }

  // كله فبنختصر  SQL الاربعة فانكشنز اللي جايين دول زي اختصار للاربعة اللي فاتو بدل ما اكتب امر ال
  // SELECT بس وهو هيعمل ال  table  كله دلوقتي هديله اسم ال  SQL هنا مثلا بدل ما كنا لما بنستدعي الفانكشن دي كنت بكتب امر ال
  // (دالة ذكية بديلة لكتابة الأوامر الطويلة، فقط نمرر لها اسم الجدول وستأتي بالبيانات)
  Future select(String table) async {
    // الحصول على قاعدة البيانات
    Database? mydb = await db;
    // أمر يقرأ كل شيء داخل الجدول المذكور ويضع الناتج في قائمة خرائط
    List<Map> response = await mydb!.query(table);
    // إرجاع المخرجات للبرنامج
    return response;
  }

  // هو اسم الكولمن key وال  key : values كباراميتر علي هيئة  values فبحط ال  values عايزة  insert  نفس الكلام هنا بس طبعا ال
  // (عملية إدخال ذكية بدون رموز أو مسافات خطرة لتجنب مشاكل SQL، وتعتمد على قاموس قيم)
  Future insert(String table, Map<String, Object?> values) async {
    // تنشيط اتصال قواعد البيانات
    Database? mydb = await db;
    // تقوم الدالة الأصلية في فلاتر بترتيب القيم وادخالها بأمان للجدول المطلوب
    int response = await mydb!.insert(table, values);
    // إرجاع إشارة برقم الصف الجديد المدرج للتعامل معه
    return response;
  }

  // عشان يعرف هيعمل ابديت فين او هيشيل فين id ده بديله ال  where مفيش اي اختلاف غير بس ان عشان اعمل ابديت فلازم احدد المكان اللي هعمل فيه ففي باراميتر
  // (عملية تعديل سهلة ومحمية لتغيير القيم وإرفاق شرط مخصص لتعديل العنصر المطلوب فقط)
  Future update(String table, Map<String, Object?> values, mywhere) async {
    // استدعاء الاتصال
    Database? mydb = await db;
    // التعديل على الجدول بناءً على القيم المدخلة وتحديدا أين تحدث באמצעות شرط mywhere
    int response = await mydb!.update(table, values, where: mywhere);
    // إرجاع عدد الصفوف المعدلة
    return response;
  }

  // (عملية الحذف الآمنة باختيار الجدول وتحديد الشرط أو العنصر الذي سيتم حذفه فقط)
  Future delete(String table, mywhere) async {
    // استدعاء الاتصال الآمن
    Database? mydb = await db;
    // تنفيذ استعلام الحذف الأصغر والآمن بمتغير الشرط
    int response = await mydb!.delete(table, where: mywhere);
    // النتيجة وعدد السجلات المتأثرة
    return response;
  }
}
