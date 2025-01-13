import 'package:gsolution/common/config/import.dart';

class ProductCategoryModule {
  ProductCategoryModule._();

  static readProductsCategory(
      {required List<int> ids,
      required OnResponse<List<ProductCategoryModel>> onResponse}) {
    List<String> fields = [
      "product_count",
      "name",
      "id",
      "parent_id",
      "route_ids",
      "total_route_ids",
      "removal_strategy_id",
      "property_cost_method",
      "property_valuation",
      "property_account_creditor_price_difference_categ",
      "property_account_income_categ_id",
      "property_account_expense_categ_id",
      "property_stock_account_input_categ_id",
      "property_stock_account_output_categ_id",
      "property_stock_valuation_account_id",
      "property_stock_journal"
    ];
    Api.read(
      model: "product.category",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<ProductCategoryModel> products = [];
        for (var element in response) {
          products.add(ProductCategoryModel.fromJson(element));
        }
        onResponse(products);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static searchReadProductsCategory({OnResponse? onResponse}) async {
    List<String> fields = [
      "parent_id",
      // "image_128",
      // "image_256",
      // // "image_512",
      // "lst_price",
      // "description",
      // "barcode"
    ];

    try {
      await Module.getRecordsController<ProductCategoryModel>(
        model: "product.category",
        fields: fields,
        domain: [
          // "&",
          // "&",
          // "&",
          // ["sale_ok", "=", "True"],
          // [
          //   "type",
          //   "in",
          //   ["consu", "product"]
          // ],
          // ["can_be_expensed", "!=", "True"],
          // ["active", "=", "True"],
        ],
        fromJson: (data) => ProductCategoryModel.fromJson(data),
        onResponse: (response) {
          onResponse!(response);
        },
      );
    } catch (e) {
      print("Error obteniendo productos: $e");
    }
  }

  static createProductCategory(
      {required Map<String, dynamic>? maps, required OnResponse onResponse}) {
    Api.create(
        model: "product.category",
        values: maps!,
        onResponse: (response) {
          if (response != null) {
            readProductsCategory(
                ids: [response],
                onResponse: (resRead) {
                  if (resRead.isNotEmpty) {
                    onResponse(resRead[0]);
                  }
                });
          }
        },
        onError: (String error, Map<String, dynamic> data) {
          print('error');
        });
  }

  static updateProductCategory(
      {required Map<String, dynamic>? maps,
      required int id,
      required OnResponse onResponse}) {
    Api.write(
        ids: [id],
        model: "product.category",
        values: maps!,
        onResponse: (response) {
          if (response != null) {
            readProductsCategory(
                ids: [id],
                onResponse: (resRead) {
                  if (resRead.isNotEmpty) {
                    onResponse(resRead[0]);
                  }
                });
          }
        },
        onError: (String error, Map<String, dynamic> data) {
          print('error');
        });
  }

  static deleteProductCategory({
    required int id,
    required OnResponse onResponse,
    required BuildContext context,
  }) {
    Api.unlink(
      model: "product.category",
      ids: [id],
      onResponse: (response) {
        if (response) {
          onResponse(response);
        }
      },
      onError: (String error, Map<String, dynamic> data) {
        // استخراج الرسالة من JSON
        String errorMessage = error;
        if (data.containsKey('error') &&
            data['error']['data'] != null &&
            data['error']['data']['message'] != null) {
          errorMessage = data['error']['data']['message'];
        }

        // عرض رسالة الخطأ داخل Dialog
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        print('Error: $errorMessage');
      },
    );
  }
}
