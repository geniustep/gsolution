import 'dart:io';
import 'package:gsolution/common/config/import.dart';
import 'package:path_provider/path_provider.dart';

class OrderModule {
  OrderModule._();
  static searchReadOrder({OnResponse? onResponse, List? domain}) async {
    List<String> fields = [
      'amount_total',
      'state',
      'activity_ids',
      'order_line',
      'invoice_count',
      'delivery_count',
      'pricelist_id',
      'payment_term_id',
      'amount_tax',
      'amount_untaxed',
      "invoice_status"
    ];

    try {
      await Module.getRecordsController<OrderModel>(
        model: "sale.order",
        fields: fields,
        domain: domain!,
        fromJson: (data) => OrderModel.fromJson(data),
        onResponse: (response) {
          onResponse!(response);
        },
      );
    } catch (e) {
      print("Error obteniendo productos: $e");
    }
  }

  static readOrders(
      {required List<int> ids,
      required OnResponse<List<OrderModel>> onResponse}) {
    List<String> fields = [
      "id",
      "authorized_transaction_ids",
      "state",
      "picking_ids",
      "delivery_count",
      "expense_count",
      "invoice_count",
      "name",
      "partner_id",
      "partner_invoice_id",
      "partner_shipping_id",
      "sale_order_template_id",
      "validity_date",
      "date_order",
      "pricelist_id",
      "currency_id",
      "payment_term_id",
      "order_line",
      "note",
      "amount_untaxed",
      "amount_tax",
      "amount_total",
      // "margin",
      "sale_order_option_ids",
      "user_id",
      "team_id",
      "company_id",
      "require_signature",
      "require_payment",
      "reference",
      "client_order_ref",
      "fiscal_position_id",
      // "analytic_account_id",
      "invoice_status",
      "warehouse_id",
      "incoterm",
      "picking_policy",
      "commitment_date",
      "expected_date",
      "effective_date",
      "origin",
      "campaign_id",
      "medium_id",
      "source_id",
      "signed_by",
      "signed_on",
      "signature",
      // "__last_update",
      "message_follower_ids",
      "activity_ids",
      "message_ids",
      "message_attachment_count",
      "display_name",
    ];
    Api.read(
      model: "sale.order",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        if (response != null) {
          List<OrderModel> partners = [];
          for (var element in response) {
            partners.add(OrderModel.fromJson(element));
          }
          onResponse(partners);
        }
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static deliteOrder(
      {required int args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "sale.order",
        method: 'unlink',
        args: [
          [args]
        ],
        onResponse: (response) {
          if (response != null) {
            onResponse(response);
          }
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }

  static cancelOrderDraft(
      {required int args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "sale.order",
        method: "action_cancel",
        args: [
          [args]
        ],
        onResponse: (response) {
          if (response is bool && response) {
            onResponse(response);
          } else if (response != null && response is Map<String, dynamic>) {
            Api.webSave(
                model: "sale.order.cancel",
                value: {"order_id": args},
                args: [],
                onResponse: (resWebSave) {
                  print(resWebSave.runtimeType);
                  if (resWebSave != null) {
                    final idRes = resWebSave[0]["id"];
                    Api.callKW(
                        model: "sale.order.cancel",
                        method: "action_cancel",
                        args: [idRes],
                        onResponse: (resCancel) {
                          print(resCancel.runtimeType);
                          if (resCancel != null && resCancel) {
                            onResponse(resCancel);
                          }
                        },
                        onError: (e, d) {
                          handleApiError(e);
                        });
                  }
                },
                onError: (e, d) {
                  handleApiError(e);
                });
          }
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }

  static cancelMethod({
    required List<int> args,
    required OnResponse<bool> onResponse,
  }) {
    Api.callKW(
      model: "sale.order",
      method: "action_cancel",
      args: [args],
      kwargs: {
        "context": {
          "params": {
            "action": "sales",
            "actionStack": [
              {"action": "sales"}
            ]
          },
          "lang": "fr_FR",
          "tz": "Africa/Casablanca",
          "uid": 2,
          "allowed_company_ids": [1]
        }
      },
      onResponse: (response) {
        if (response != null) {
          print("First response: $response");
          try {
            final resModel = response['res_model'];
            final context = response['context'];

            if (resModel != "sale.order.cancel" || context == null) {
              throw Exception("Unexpected res_model or missing context");
            }

            final kwargsForSecondCall = {
              "context": {
                ...context,
                "params": {
                  "action": "sales",
                  "actionStack": [
                    {"action": "sales"}
                  ]
                },
                "lang": "fr_FR",
                "tz": "Africa/Casablanca",
                "uid": 2,
                "allowed_company_ids": [1],
                "active_model": "sale.order",
                "active_id": args.first,
                "active_ids": args,
              }
            };

            Api.callKW(
              model: "sale.order.cancel",
              method: "action_cancel",
              args: [1],
              kwargs: kwargsForSecondCall,
              onResponse: (resCancel) {
                if (resCancel != null) {
                  onResponse(true);
                } else {
                  onResponse(false);
                }
              },
              onError: (error, data) {
                handleApiError(error);
                onResponse(false);
              },
            );
          } catch (e) {
            print("Error parsing first response: $e");
            onResponse(false);
          }
        } else {
          print("No response from first call");
          onResponse(false);
        }
      },
      onError: (error, data) {
        handleApiError(error);
        onResponse(false);
      },
    );
  }

  static draftMethod(
      {required List<int> args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "sale.order",
        method: "action_draft",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static pricelist({required OnResponse<dynamic> onResponse}) {
    Api.callKW(
        model: "product.pricelist",
        method: "name_search",
        args: [],
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static accountPaymentTerm({required OnResponse<dynamic> onResponse}) {
    Api.callKW(
        model: "account.payment.term",
        method: "name_search",
        args: [],
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static saleOrderTemplate({required OnResponse<dynamic> onResponse}) {
    Api.callKW(
        model: "sale.order.template",
        method: "name_search",
        args: [],
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static createSaleOrder(
      {required Map<String, dynamic>? maps,
      required OnResponse onResponse}) async {
    Map<String, dynamic> newMap = Map.from(maps!);
    await Module.createModule(
      model: "sale.order",
      maps: newMap,
      onResponse: (response) {
        onResponse(response);
      },
    );
  }

  static updateSaleOrder(
      {required Map<String, dynamic>? maps,
      required List<int> ids,
      required OnResponse onResponse}) async {
    Map<String, dynamic> newMap = Map.from(maps!);
    await Module.writeModule(
      model: "sale.order",
      ids: ids,
      values: newMap,
      onResponse: (response) {
        onResponse(response);
      },
    );
  }

  static confirmOrder(
      {required List<int> args, required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "sale.order",
        method: "action_confirm",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static actionViewDelivery({
    required List<int> args,
    required OnResponse<List<int>> onResponse,
  }) {
    Api.callKW(
      model: "sale.order",
      method: "action_view_delivery",
      args: args,
      onResponse: (response) {
        if (response is Map<String, dynamic>) {
          if (response['res_id'] != 0) {
            onResponse([response['res_id']]);
          } else if (response['domain'] != null) {
            final domain = response['domain'] as List?;
            if (domain != null && domain.isNotEmpty) {
              final idFilter = domain.firstWhere(
                (item) => item is List && item.length == 3 && item[0] == "id",
                orElse: () => null,
              );

              if (idFilter != null && idFilter is List) {
                final ids = idFilter[2].cast<int>();
                onResponse(ids);
              } else {
                onResponse([]);
              }
            } else {
              onResponse([]);
            }
          } else {
            onResponse([]);
          }
        } else {
          onResponse([]);
        }
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static printDevisHtml(
      {required OnResponse onResponse, required int id}) async {
    await Api.printReporthtml(
        reportName: 'sale.report_saleorder',
        recordId: id,
        onResponse: (response) async {
          final String contentBase64 = base64Encode(
            const Utf8Encoder().convert(response),
          );
          onResponse(contentBase64);
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }

  static printDevisPdf(
      {required OnResponse onResponse, required int id}) async {
    await Api.printReportPdf(
        reportName: 'sale.report_saleorder',
        recordId: id,
        onResponse: (response) async {
          final directory = await getDownloadsDirectory();
          final savePath = '${directory!.path}/sales_$id.pdf';
          final file = File(savePath);
          await file.writeAsBytes(response);
          onResponse(savePath);
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }
}
