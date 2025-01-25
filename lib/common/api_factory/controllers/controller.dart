import 'package:gsolution/common/api_factory/models/invoice/account_journal/account_journal_module.dart';
import 'package:gsolution/common/api_factory/models/invoice/account_move_line/account_move_line_module.dart';
import 'package:gsolution/common/api_factory/models/resgroups/res_groups_model.dart';
import 'package:gsolution/common/api_factory/models/resgroups/res_groups_module.dart';
import 'package:gsolution/common/api_factory/modules/api_sync.dart';
import 'package:gsolution/common/api_factory/modules/settings_odoo.dart';
import 'package:gsolution/common/config/hive/hive_corpe.dart';
import 'package:gsolution/common/config/hive/hive_service.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';

class Controller extends GetxController {
  var products = <ProductModel>[].obs;
  var partners = <PartnerModel>[].obs;
  var categoryProduct = <ProductCategoryModel>[].obs;
  var sales = <OrderModel>[].obs;
  var orderLine = <OrderLineModel>[].obs;
  var accountMove = <AccountMoveModel>[].obs;
  var accountJournal = <AccountJournalModel>[].obs;
  var settingsOdoo = ResConfigSettingModel().obs;
  var resGroups = <ResGroupsModel>[].obs;
  var accountMoveLine = <AccountMoveLineModel>[].obs;
  var hiveProduct = HiveCorpe.hiveProduct;

  @override
  void onInit() {
    super.onInit();
  }

// Settings Odooo
  Future<void> getSettingsOdooController({OnResponse? onResponse}) async {
    await Module.onchangeSettingsOdoo(onResponse: (response) async {
      try {
        settingsOdoo.value = response;
        if (settingsOdoo.value.id != null &&
            settingsOdoo.value.default_invoice_policy != "delivery") {
          await Module.deliverySettings(onResponse: (res) {
            onResponse!(true);
          });
        } else {
          onResponse!(true);
        }
      } catch (e) {
        print("Error obteniendo Partners: $e");
        handleApiError(e);
      }
    });
  }

  Future<void> getResGroupsController({OnResponse? onResponse}) async {
    await ResGroupsModule.getResGroups(onResponse: (response) async {
      try {
        if (response != null) {
          resGroups.addAll(response);
          if (resGroups.isNotEmpty) {
            final int idGroups = resGroups[0].id!;
            ResGroupsModule.resGroupsRead(
                ids: [idGroups],
                onResponse: (resRead) {
                  if (resRead != null) {
                    debugPrint(resRead.runtimeType.toString());
                    debugPrint(resRead.toString());
                    if (resRead != null &&
                        !resRead.contains(PrefUtils.user.value.uid)) {
                      resRead.add(PrefUtils.user.value.uid);
                      if (PrefUtils.user.value.isAdmin!) {
                        ResGroupsModule.writeResGroups(
                            id: idGroups,
                            idsUser: resRead.cast<int>(),
                            onResponse: (resWrite) {
                              try {
                                debugPrint(resWrite.runtimeType.toString());
                                debugPrint(resWrite.toString());
                                onResponse!(resWrite);
                              } catch (e) {
                                onResponse!(true);
                              }
                            });
                      } else {
                        onResponse!(true);
                      }
                    } else {
                      onResponse!(true);
                    }
                  }
                });
          }
        }
      } catch (e) {
        handleApiError(e);
      }
    });
  }

// Partners
  Future<void> getPartnersController({OnResponse? onResponse}) async {
    await PartnerModule.searchReadPartners(onResponse: (response) {
      try {
        partners.clear();
        partners.addAll(response);
        onResponse!(partners);
      } catch (e) {
        print("Error obteniendo Partners: $e");
        handleApiError(e);
      }
    });
  }

// products
  Future<void> loadProducts() async {
    products.clear();
    List<ProductModel> cachedProducts = await HiveService.getProducts();
    if (cachedProducts.isNotEmpty) {
      await ApiSync.checkRecordInOdoo(
          model: 'product.template',
          onResponse: (response) async {
            if (response != null && response is Map<String, dynamic>) {
              int productLenght = response['model_length'];
              if (cachedProducts.length == productLenght) {
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

  Future<void> fetchProductsFromOdoo() async {
    await ProductModule.searchReadProducts(
      onResponse: (response) async {
        try {
          products.clear();
          products.addAll(response);
          await hiveProduct.clearData(
            onResponse: (response) {},
          );
          await HiveService.saveProducts(response);
        } catch (e) {
          print("Error fetching products: \$e");
          handleApiError(e);
        }
      },
    );
  }

  Future<void> getProductsController({OnResponse? onResponse}) async {
    await ProductModule.searchReadProducts(
      onResponse: (response) {
        try {
          products.clear();
          products.addAll(response);
          onResponse!(products);
        } catch (e) {
          print("Error obteniendo productos: $e");
          handleApiError(e);
        }
      },
    );
  }

// category product

  Future<void> getCategoryProductsController({OnResponse? onResponse}) async {
    try {
      await ProductCategoryModule.searchReadProductsCategory(
          onResponse: (response) {
        categoryProduct.clear();
        categoryProduct.addAll(response);
        onResponse!(categoryProduct);
      });
    } catch (e) {
      print("Error obteniendo productos: $e");
      handleApiError(e);
    }
  }

// sales order
  Future<void> getSalesController(
      {OnResponse? onResponse, List? domain}) async {
    try {
      await OrderModule.searchReadOrder(
        domain: domain ?? [],
        onResponse: (response) {
          sales.clear();
          sales.addAll(response);
          onResponse!(sales);
        },
      );
    } catch (e) {
      print("Error obteniendo: $e");
      handleApiError(e);
    }
  }

// order line
  Future<void> getSalesLineController({OnResponse? onResponse}) async {
    await OrderLineModule.searchReadOrderLine(onResponse: (response) {
      try {
        orderLine.clear();
        orderLine.addAll(response);
        onResponse!(orderLine);
      } catch (e) {
        print("Error obteniendo: $e");
        handleApiError(e);
      }
    });
  }

  getSalesOrdersLineController({List<int>? ids, OnResponse? onResponse}) async {
    await OrderLineModule.readOrderLines(
        ids: ids!,
        onResponse: (response) {
          if (response.isNotEmpty) {
            orderLine.clear();
            orderLine.addAll(response);
            int key = orderLine.isNotEmpty ? orderLine[0].id as int : 0;
            onResponse!({key: orderLine});
          }
        });
  }

  ////////////////////////////////////////
  /////////////** INVOICE **//////////////
  ////////////////////////////////////////
  // ACCONT MOVE
  getAccountMove({OnResponse? onResponse}) async {
    try {
      await AccountMoveModule.searchReadAccountMove(onResponse: (response) {
        accountMove.clear();
        accountMove.addAll(response);
        onResponse!(accountMove);
      });
    } catch (e) {
      print("Error obteniendo: $e");
      handleApiError(e);
    }
  }

  Future<void> getAccuontMoveLineController(
      {List<int>? ids,
      OnResponse? onResponse,
      Map<String, dynamic>? context}) async {
    await AccountMoveLineModule.readAccountMoveLine(
        context: context,
        ids: ids!,
        onResponse: ((response) {
          if (response.isNotEmpty) {
            accountMoveLine.clear();
            accountMoveLine.addAll(response);
            int key = ids.length;
            onResponse!({key: accountMoveLine});
          }
        }));
  }

//Account Journal
  getAccountJournal({OnResponse? onResponse}) async {
    try {
      await AccountJournalModule.searchReadAccountJournal(
          onResponse: (response) {
        accountJournal.clear();
        accountJournal.addAll(response);
        onResponse!(accountJournal);
      });
    } catch (e) {
      print("Error obteniendo: $e");
      handleApiError(e);
    }
  }

  /// *********** END INVOICE **** ///////
}
