import 'package:gsolution/common/config/hive/hive_corpe.dart';
import 'package:gsolution/common/config/import.dart';

class ApiSync {
  ApiSync();

  static checkRecordInOdoo(
      {required String model, required OnResponse onResponse}) async {
    // ✅ التحقق مما إذا كان هناك تحديثات من FastAPI
    await Api.webhookCheckOdoo(
        model: model,
        onResponse: (response) async {
          print(response.runtimeType);
          final Map<String, dynamic> map = {
            "has_updates": response['has_updates'],
            "model_length": response['model_length']
          };
          if (response['has_updates']) {
            await Api.webhookFetchOdoo(
                model: model,
                onResponse: (resFetch) async {
                  if (resFetch is List<dynamic>) {
                    List<int> ids = [];
                    for (var element in resFetch) {
                      ids.add(element['record_id']);
                    }

                    List<dynamic> createUpdateList = [];
                    List<dynamic> deleteList = [];
                    final hiveProduct = HiveCorpe.hiveProduct;
                    // ✅ حذف جميع `record_id` من Hive قبل التحديث
                    await hiveProduct.deleteItemsById(
                        ids: ids,
                        onResponse: (resDeleteItemsById) async {
                          for (var record in resFetch) {
                            if (record["operation"] == "deleted") {
                              deleteList.add(record);
                            } else {
                              createUpdateList.add(record);
                            }
                          }

                          // ✅ إذا كان هناك عناصر في `createUpdateList`، جلب بياناتها من Odoo
                          if (createUpdateList.isNotEmpty) {
                            List<int> newIds = [];
                            for (var element in createUpdateList) {
                              newIds.add(element['record_id']);
                            }

                            await ProductModule.readProducts(
                                ids: newIds,
                                onResponse: (resRead) async {
                                  await hiveProduct.saveDataById(
                                    items: resRead,
                                    getId: (item) => item.id,
                                    onResponse: (response) {
                                      onResponse(map);
                                    },
                                  );
                                },
                                onError: (e, d) {
                                  handleApiError(e);
                                });
                          }
                        });
                  }
                },
                onError: (e, d) {
                  handleApiError(e);
                });
          } else {
            onResponse(map);
          }
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }
}
