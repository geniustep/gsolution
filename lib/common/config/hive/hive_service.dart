import 'package:gsolution/common/api_factory/models/product/product_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static late Box<ProductModel> productBox;

  /// **تهيئة Hive عند بدء التطبيق**
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductModelAdapter());
    productBox = await Hive.openBox<ProductModel>('productsBox');
  }

  /// **حفظ قائمة المنتجات في Hive**
  static Future<void> saveProducts(List<ProductModel> products) async {
    await productBox.clear();
    await productBox.addAll(products);
  }

  /// **استرجاع المنتجات المخزنة في Hive**
  static List<ProductModel> getProducts() {
    return productBox.values.toList();
  }

  /// **حذف جميع البيانات المخزنة في Hive**
  static Future<void> clearProducts() async {
    await productBox.clear();
  }
}
