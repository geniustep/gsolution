import 'package:gsolution/common/config/hive/hive_corpe.dart';
import 'package:gsolution/common/config/hive/hive_service.dart';
import 'package:gsolution/common/config/import.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var hiveProduct = HiveCorpe.hiveProduct;

  /// **1️⃣ Load products from Hive or Odoo**
  Future<void> loadProducts() async {
    products.clear();
    List<ProductModel> cachedProducts = await HiveService.getProducts();

    if (cachedProducts.isNotEmpty) {
      await checkWebhookProduct(
          model: 'product.template',
          onResponse: (response) async {
            if (response != null && response is Map<String, dynamic>) {
              int productLength = response['model_length'];

              if (cachedProducts.length == productLength) {
                products.addAll(cachedProducts);
              } else {
                await fetchProductsFromOdoo();
              }
            }
          });
    } else {
      await fetchProductsFromOdoo();
    }
  }

  /// **2️⃣ Fetch products from Odoo and update Hive**
  Future<void> fetchProductsFromOdoo() async {
    await ProductModule.searchReadProducts(
      onResponse: (response) async {
        try {
          // ✅ Ensure response is not empty before processing
          if (response.isNotEmpty) {
            products.clear();
            products.addAll(response);

            // ✅ Clear Hive data before saving new products
            await hiveProduct.clearData(onResponse: (resClear) async {
              if (resClear == true) {
                // ✅ Ensure Hive data was cleared successfully
                await HiveService.saveProducts(response);
                debugPrint("✅ Products updated successfully in Hive.");
              } else {
                debugPrint(
                    "⚠️ Failed to clear data in Hive, products were not updated.");
              }
            });
          } else {
            debugPrint("⚠️ No products retrieved from Odoo.");
          }
        } catch (e) {
          debugPrint("❌ Error while fetching products from Odoo: $e");
          handleApiError(e);
        }
      },
    );
  }

  /// **3️⃣ Check for Webhook updates**
  Future<void> checkWebhookProduct(
      {required String model, required OnResponse onResponse}) async {
    await Api.webhookCheckOdoo(
      model: model,
      onResponse: (response) async {
        try {
          if (response != null && response is Map<String, dynamic>) {
            bool hasUpdates = response['has_updates'] ?? false; // Avoid null
            if (hasUpdates) {
              await fetchWebhookProduct(
                  model: model,
                  onResponse: (resFetch) {
                    onResponse(resFetch);
                  });
            } else {
              onResponse(response);
            }
          }
        } catch (e) {
          print("❌ خطأ أثناء التحقق من Webhook: $e");
          handleApiError(e);
        }
      },
      onError: (error, data) {
        print("❌ خطأ أثناء استدعاء Webhook Check: $error");
        handleApiError(error);
      },
    );
  }

  /// **4️⃣ Fetch updates from Webhook**
  Future<void> fetchWebhookProduct(
      {required String model, required OnResponse onResponse}) async {
    await Api.webhookFetchOdoo(
      model: model,
      onResponse: (response) async {
        try {
          if (response is List<dynamic>) {
            List<int> ids = response.map((e) => e['record_id'] as int).toList();

            if (ids.isNotEmpty) {
              await deleteHiveProduct(
                  ids: ids,
                  onResponse: (resDelete) {
                    onResponse(response);
                  });
            }
          }
        } catch (e) {
          debugPrint("❌ Error fetching data from Webhook: $e");
          handleApiError(e);
        }
      },
      onError: (error, data) {
        debugPrint("❌ Error calling Webhook Fetch: $error");
        handleApiError(error);
      },
    );
  }

  /// **5️⃣ Delete old data from Hive and update new records**
  Future<void> deleteHiveProduct(
      {required List<int> ids, required OnResponse onResponse}) async {
    try {
      await hiveProduct.deleteItemsById(
        ids: ids,
        onResponse: (response) async {
          List<int> createUpdateIds = [];
          List<int> deleteIds = [];

          for (var record in response) {
            if (record["operation"] == "deleted") {
              deleteIds.add(record["record_id"]);
            } else {
              createUpdateIds.add(record["record_id"]);
            }
          }

          if (createUpdateIds.isNotEmpty) {
            await ProductModule.readProducts(
                ids: createUpdateIds,
                onResponse: (resRead) async {
                  await hiveProduct.saveDataById(
                    items: resRead,
                    getId: (item) => item.id,
                    onResponse: (response) async {
                      // ✅ Clear Webhook after updating Hive only if the operation succeeds
                      if (response == true) {
                        await clearWebhookProduct(
                            model: "product.template",
                            onResponse: (resClear) {
                              debugPrint("✅ Webhook cleared after Hive update");
                            });
                      }
                      onResponse(response);
                    },
                  );
                },
                onError: (e, d) {
                  debugPrint("❌ Error reading products from Odoo: $e");
                  handleApiError(e);
                });
          }

          if (deleteIds.isNotEmpty) {
            await hiveProduct.deleteItemsById(
              ids: deleteIds,
              onResponse: (response) {
                debugPrint("✅ Deleted removed items from Hive");
              },
            );
          }
        },
      );
    } catch (e) {
      debugPrint("❌ Error updating data in Hive: $e");
      handleApiError(e);
    }
  }

  /// **6️⃣ Clear Webhook data**
  Future<void> clearWebhookProduct(
      {required String model, required OnResponse onResponse}) async {
    await Api.clearWebhookData(
      model: model,
      onResponse: (response) {
        if (response != null && response['status'] == 'success') {
          debugPrint("✅ Webhook cleared successfully");
          onResponse(response);
        } else {
          debugPrint("⚠️ Webhook was not cleared successfully");
          onResponse({"message": "No data cleared"});
        }
      },
      onError: (error, data) {
        debugPrint("❌ Error clearing Webhook: $error");
        handleApiError(error);
      },
    );
  }
}
