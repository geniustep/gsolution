import 'package:flutter/foundation.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/common/config/import.dart';

class ProductModule {
  ProductModule._();
  static searchReadProducts<T>({
    OnResponse? onResponse,
  }) async {
    List<String> fields = [
      "image_512",
      "image_1920",
      'qty_available',
      'virtual_available',
      'taxes_id',
      "lst_price",
      "description",
      "barcode",
      "default_code",
      "active",
      "write_date",
    ];

    List<String> fieldsDebug = [
      'qty_available',
      'virtual_available',
      'taxes_id',
      "lst_price",
      "description",
      "barcode",
      "default_code",
      "active",
      "write_date",
    ];

    List<dynamic> domain = [
      "&",
      // "&",
      // "&",
      // ["sale_ok", "=", "True"],
      // [
      //   "type",
      //   "in",
      //   ["consu", "product"]
      // ],
      ["can_be_expensed", "!=", "True"],
      ["active", "=", "True"],
    ];

    try {
      await Module.getRecordsController<ProductModel>(
        model: "product.product",
        fields: kReleaseMode ? fields : fieldsDebug,
        domain: domain,
        fromJson: (data) => ProductModel.fromJson(data),
        onResponse: (response) {
          onResponse!(response);
        },
      );
    } catch (e) {
      print("Error obteniendo productos: $e");
    }
  }

  static readProducts(
      {required List<int> ids,
      required OnResponse<List<ProductModel>> onResponse,
      OnError? onError}) {
    List<String> fields = [
      "product_variant_count",
      "is_product_variant",
      "attribute_line_ids",
      "qty_available",
      "uom_name",
      "virtual_available",
      "reordering_min_qty",
      "reordering_max_qty",
      "nbr_reordering_rules",
      "sales_count",
      "id",
      "image_1920",
      "image_128",
      "image_256",
      "image_128",
      "name",
      "sale_ok",
      "purchase_ok",
      "active",
      "type",
      "categ_id",
      "default_code",
      "barcode",
      "list_price",
      "valuation",
      "cost_method",
      "pricelist_item_count",
      "taxes_id",
      "standard_price",
      "company_id",
      "uom_id",
      "uom_po_id",
      "currency_id",
      "cost_currency_id",
      "product_variant_id",
      "description",
      "invoice_policy",
      "service_type",
      "visible_expense_policy",
      "expense_policy",
      "description_sale",
      "sale_line_warn",
      "sale_line_warn_msg",
      "supplier_taxes_id",
      "route_ids",
      "route_from_categ_ids",
      "sale_delay",
      "tracking",
      "property_stock_production",
      "property_stock_inventory",
      "weight",
      "weight_uom_name",
      "volume",
      "volume_uom_name",
      "responsible_id",
      "packaging_ids",
      "description_pickingout",
      "description_pickingin",
      "description_picking",
      "property_account_income_id",
      "property_account_expense_id",
      "message_follower_ids",
      "activity_ids",
      "message_ids",
      "message_attachment_count",
      "display_name",
      "can_be_expensed"
    ];
    Api.read(
      model: "product.template",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<ProductModel> products = [];
        for (var element in response) {
          products.add(ProductModel.fromJson(element));
        }
        onResponse(products);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static createProduct({
    required Map<String, dynamic>? maps,
    int offset = 0,
    required OnResponse<Map<int, List<ProductModel>>> onResponse,
  }) {
    Map<String, dynamic> newMap = Map.from(maps!);
    Api.create(
      model: "product.template",
      values: newMap,
      onResponse: (response) {
        ProductModule.readProducts(
          ids: [response],
          onResponse: (responseProducts) {
            // إضافة المنتج الجديد إلى PrefUtils.products
            PrefUtils.products.add(responseProducts[0]);

            // إرجاع المنتج الجديد عند العودة
            Get.back(result: responseProducts[0]);
          },
        );
      },
      onError: (String error, Map<String, dynamic> data) {
        print('error');
      },
    );
  }

  static updateProduct(
      {required Map<String, dynamic>? maps,
      required int id,
      required OnResponse onResponse}) {
    Api.write(
      model: "product.template",
      ids: [id],
      values: maps!,
      onResponse: (response) {
        readProducts(ids: [id], onResponse: (onResponse) {});
      },
      onError: (String error, Map<String, dynamic> data) {
        print('error');
      },
    );
  }

  static deleteProduct({
    required int id,
    required OnResponse onResponse,
    required BuildContext context,
  }) {
    Api.unlink(
      model: "product.template",
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
