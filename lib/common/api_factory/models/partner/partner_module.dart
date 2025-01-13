import 'package:flutter/foundation.dart';
import 'package:gsolution/common/config/import.dart';
import 'package:gsolution/common/config/prefs/pref_utils.dart';
import 'package:gsolution/src/presentation/screens/customer/customer_main_screen.dart';

class PartnerModule {
  PartnerModule._();

  static readPartners(
      {required List<int> ids,
      required OnResponse<List<PartnerModel>> onResponse}) {
    List<String> fields = [
      "image_512",
      "image_1920",
      "name",
      "title",
      "parent_id",
      "parent_name",
      "child_ids",
      "ref",
      "user_id",
      "bank_ids",
      "active",
      "employee",
      "function",
      "type",
      "street",
      "city",
      "partner_latitude",
      "partner_longitude",
      "email",
      "mobile",
      "is_company",
      "barcode",
      "id",
      "invoice_warn",
      "invoice_warn_msg",
      "supplier_rank",
      "customer_rank",
      "purchase_order_count",
      "supplier_invoice_count",
      "purchase_warn",
      "purchase_warn_msg",
      "buyer_id",
      "purchase_line_ids",
      "sale_order_count",
      "sale_order_ids",
      "sale_warn",
      "sale_warn_msg",
    ];
    Api.read(
      model: "res.partner",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<PartnerModel> partners = [];
        for (var element in response) {
          partners.add(PartnerModel.fromJson(element));
        }
        onResponse(partners);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static searchReadPartners({OnResponse? onResponse, dynamic domain}) async {
    List<String> fields = [
      "image_512",
      "image_1920",
      "name",
      "title",
      "parent_id",
      "parent_name",
      "child_ids",
      "ref",
      "user_id",
      "bank_ids",
      "active",
      "employee",
      "function",
      "type",
      "street",
      "city",
      "partner_latitude",
      "partner_longitude",
      "email",
      "mobile",
      "is_company",
      "barcode",
      "id",
      "invoice_warn",
      "invoice_warn_msg",
      "supplier_rank",
      "customer_rank",
      "purchase_order_count",
      "supplier_invoice_count",
      "purchase_warn",
      "purchase_warn_msg",
      "buyer_id",
      "purchase_line_ids",
      "sale_order_count",
      "sale_order_ids",
      "sale_warn",
      "sale_warn_msg",
      'total_invoiced',
      'payment_token_count',
    ];
    List<String> fieldsDebug = [
      "function",
      "name",
      "street",
      "city",
      "partner_latitude",
      "partner_longitude",
      "email",
      "mobile",
      "is_company",
      "barcode",
      "customer_rank",
      "supplier_rank",
      "child_ids",
      "sale_order_count",
      'total_invoiced',
      'payment_token_count',
    ];
    domain = [];

    try {
      await Module.getRecordsController<PartnerModel>(
        model: "res.partner",
        fields: kReleaseMode ? fields : fieldsDebug,
        domain: domain,
        fromJson: (data) => PartnerModel.fromJson(data),
        onResponse: (response) {
          onResponse!(response);
        },
      );
    } catch (e) {
      print("Error obteniendo Partners: $e");
    }
  }

  static createPartners(
      {required Map<String, dynamic>? maps,
      required OnResponse<int> onResponse}) {
    Api.create(
        model: "res.partner",
        values: maps!,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (String error, Map<String, dynamic> data) {
          print('error');
        });
  }

  static updateResPartner({
    required PartnerModel partner,
    required Map<String, dynamic>? maps,
    required OnResponse onResponse,
  }) {
    print(PrefUtils.partners.length);
    PrefUtils.partners.removeWhere((p) => p.id == partner.id);
    Api.webSave(
      model: "res.partner",
      args: [partner.id!],
      value: maps!,
      specification: {},
      onResponse: (response) {
        print("Update successful: $response");
        try {
          print(PrefUtils.partners.length);
          PartnerModule.readPartners(
              ids: [partner.id],
              onResponse: (resPartner) async {
                onResponse(resPartner);
                await PrefUtils.updatePartner(resPartner[0]);
                print(PrefUtils.partners.length);
                Get.off(() => CustomerMainScreen());
                // Get.off(() => Partner(onResponse[0]));
              });
        } catch (e) {
          print(e.toString());
        }
      },
      onError: (error, data) {
        print("Error: $error");
      },
    );
    // Module.writeModule(
    //   model: "res.partner",
    //   ids: [partner.id!],
    //   values: maps!,
    //   onResponse: (response) {
    //     try {
    //       print(PrefUtils.partners.length);
    //       PartnerModule.readPartners(
    //           ids: [partner.id],
    //           onResponse: (resPartner) async {
    //             onResponse(resPartner);
    //             await PrefUtils.updatePartner(resPartner[0]);
    //             print(PrefUtils.partners.length);
    //             Get.off(() => CustomerMainScreen());
    //             // Get.off(() => Partner(onResponse[0]));
    //           });
    //     } catch (e) {
    //       print(e.toString());
    //     }
    //   },
    // );
  }
}
