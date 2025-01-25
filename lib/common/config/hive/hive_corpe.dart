import 'package:gsolution/common/config/hive/hive_key.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCorpe<T> {
  final String boxName;

  HiveCorpe(this.boxName);
  static final hiveProduct = HiveCorpe<ProductModel>(HiveKey.productsBox);

  static Future<void> initHive() async {
    await Hive.initFlutter();

    // تسجيل كل محول بشكل صريح
    _registerAdapter<ProductModel>(ProductModelAdapter());
    _registerAdapter<PartnerModel>(PartnerModelAdapter());
  }

  /// **دالة خاصة لتسجيل الـ Adapter مع التأكد من عدم تكرار التسجيل**
  static void _registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter<T>(adapter);
    }
  }

  /// **فتح صندوق Hive بناءً على اسم الصندوق ونوع البيانات**
  Future<Box<T>> openBox() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        var existingBox = Hive.box<T>(boxName);
        return existingBox; // ✅ إذا كان `Box` مفتوحًا ونوعه صحيح، نعيده
      }
      return await Hive.openBox<T>(
          boxName); // ✅ فتح `Box` فقط إذا لم يكن مفتوحًا
    } catch (e) {
      print("❌ خطأ أثناء فتح `Box`: $e");
      rethrow;
    }
  }

  /// **حفظ عدة عناصر في Hive باستخدام `id` كمفتاح فريد**
  Future<void> saveDataById(
      {required List<T> items,
      required dynamic Function(T) getId,
      required OnResponse onResponse}) async {
    try {
      var box = await openBox();
      for (var item in items) {
        var id = getId(item);
        if (id != null) {
          await box.put(id, item);
        }
      }
      onResponse(true);
    } catch (e) {
      print("❌ خطأ أثناء حفظ البيانات في `Hive`: $e");
      onResponse(false);
    }
  }

  /// **جلب جميع البيانات لأي موديل عام**
  Future<List<T>> getData() async {
    try {
      var box = await openBox();
      return box.values.toList();
    } catch (e) {
      print("❌ خطأ أثناء جلب البيانات من `Hive`: $e");
      return [];
    }
  }

  /// **مسح البيانات المخزنة في أي صندوق**
  Future<void> clearData({required OnResponse onResponse}) async {
    try {
      var box = await openBox();
      if (box.isNotEmpty) {
        await box.clear();
        print("✅ تم مسح البيانات بنجاح من `Hive`");
      }
    } catch (e) {
      print("❌ خطأ أثناء مسح البيانات: $e");
    }
  }

  /// **حذف عدة عناصر من الصندوق بناءً على قائمة `id`**
  Future<void> deleteItemsById(
      {required List<dynamic> ids, required OnResponse onResponse}) async {
    try {
      var box = await openBox();
      if (ids.isNotEmpty) {
        await box.deleteAll(ids);
        onResponse(true);
      } else {
        onResponse(false);
      }
    } catch (e) {
      print("❌ خطأ أثناء حذف البيانات من `Hive`: $e");
      onResponse(false);
    }
  }

  /// **تحديث عنصر داخل `Hive` بناءً على `id`**
  Future<void> updateDataById(T updatedItem, dynamic Function(T) getId) async {
    try {
      var box = await openBox();
      var id = getId(updatedItem);

      if (id != null && box.containsKey(id)) {
        await box.put(id, updatedItem);
        print("✅ تم تحديث العنصر بنجاح في `Hive`");
      } else {
        print("⚠️ العنصر غير موجود للتحديث.");
      }
    } catch (e) {
      print("❌ خطأ أثناء تحديث البيانات: $e");
    }
  }
}
