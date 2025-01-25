import 'package:gsolution/common/config/hive/hive_key.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  /// **حفظ المنتجات في `Hive` مع `hiveWriteDate` محدث تلقائيًا**
  static Future<void> saveProducts(List<ProductModel> products) async {
    var productsBox = await Hive.openBox<ProductModel>(HiveKey.productsBox);
    for (var product in products) {
      product.hiveWriteDate = DateTime.now().millisecondsSinceEpoch;
      await productsBox.put(product.id, product);
    }
  }

  /// **جلب جميع المنتجات المخزنة في Hive**
  static Future<List<ProductModel>> getProducts() async {
    var box = await Hive.openBox<ProductModel>(HiveKey.productsBox);
    return box.values.toList();
  }

  /// **حفظ الشركاء في `Hive` مع `hiveWriteDate` محدث تلقائيًا**
  static Future<void> savePartners(List<PartnerModel> partners) async {
    var partnersBox = await Hive.openBox<PartnerModel>(HiveKey.partnersBox);
    for (var partner in partners) {
      partner.hiveWriteDate = DateTime.now().millisecondsSinceEpoch;
      await partnersBox.put(partner.id, partner);
    }
  }

  /// **جلب جميع الشركاء المخزنين في Hive**
  static Future<List<PartnerModel>> getPartners() async {
    var box = await Hive.openBox<PartnerModel>(HiveKey.partnersBox);
    return box.values.toList();
  }
}
