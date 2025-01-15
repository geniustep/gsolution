import 'dart:io';

import 'package:gsolution/common/config/import.dart';
import 'package:path_provider/path_provider.dart';

class StockPickingModule {
  StockPickingModule._();

  static readStockPicking(
      {required List<int> ids,
      required OnResponse<List<StockPickingModel>> onResponse}) {
    List<String> fields = [
      "id",
      "is_locked",
      "show_mark_as_todo",
      "show_check_availability",
      "show_validate",
      "show_lots_text",
      "immediate_transfer",
      "show_operations",
      "show_reserved",
      "move_line_exist",
      "has_packages",
      "state",
      "picking_type_entire_packs",
      "has_scrap_move",
      "has_tracking",
      "name",
      "partner_id",
      "picking_type_id",
      "location_id",
      "location_dest_id",
      "backorder_id",
      "scheduled_date",
      "date_done",
      "origin",
      "owner_id",
      "move_line_nosuggest_ids",
      "package_level_ids_details",
      "move_line_ids_without_package",
      "move_ids_without_package",
      "package_level_ids",
      "picking_type_code",
      "move_type",
      "priority",
      "user_id",
      "group_id",
      "company_id",
      "note",
      "message_follower_ids",
      "activity_ids",
      "message_ids",
      "message_attachment_count",
      "display_name"
    ];
    Api.read(
      model: "stock.picking",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<StockPickingModel> stockPicking = [];
        for (var element in response) {
          stockPicking.add(StockPickingModel.fromJson(element));
        }
        onResponse(stockPicking);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static searchStockPickingPartnersId(
      {int offset = 0,
      List<dynamic>? domain,
      required OnResponse<dynamic> onResponse}) {
    List<String> fields = [
      "name",
      "location_id",
      "location_dest_id",
      "partner_id",
      "user_id",
      "date",
      "scheduled_date",
      "origin",
      "group_id",
      "backorder_id",
      "state",
      "priority",
      "picking_type_id",
      "company_id",
    ];
    Api.searchRead(
        model: "stock.picking",
        domain: domain!,
        offset: offset,
        fields: fields,
        onResponse: (response) {
          if (response != null) {
            onResponse(response["records"]);
          }
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static searchStockPicking(
      {int offset = 0,
      List<dynamic>? domain,
      required OnResponse<Map<int, List<StockPickingModel>>> onResponse}) {
    List<String> fields = [
      "name",
      "location_id",
      "location_dest_id",
      "partner_id",
      "user_id",
      "date",
      "scheduled_date",
      "origin",
      "group_id",
      "backorder_id",
      "state",
      "priority",
      "picking_type_id",
      "company_id",
    ];
    const int LIMIT = 0;
    List<StockPickingModel> stockPicking = [];
    Api.searchRead(
        model: "stock.picking",
        domain: domain!,
        limit: LIMIT,
        offset: offset,
        fields: fields,
        onResponse: (response) {
          if (response != null) {
            for (var element in response["records"]) {
              stockPicking.add(StockPickingModel.fromJson(element));
            }
            onResponse({response["length"]: stockPicking});
          }
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static webRead({
    required bool isOneId,
    required List<int> args,
    required OnResponse<List<StockPickingModel>> onResponse,
  }) {
    List<StockPickingModel> stockPicking = [];
    Api.callKW(
      model: "stock.picking",
      method: isOneId ? "web_read" : "web_search_read",
      args: isOneId ? args : [],
      kwargs: {
        if (!isOneId)
          "domain": [
            ["id", "in", args]
          ],
        "specification": {
          "state": {},
          "products_availability_state": {},
          "products_availability": {},
          "move_ids_without_package": {
            "fields": {
              "id": {},
              "name": {},
              "forecast_availability": {},
              "product_uom_qty": {},
              "quantity": {},
              "product_id": {
                "fields": {
                  "display_name": {},
                }
              },
            }
          },
          "name": {},
          "partner_id": {
            "fields": {
              "display_name": {},
            }
          },
          "picking_type_id": {
            "fields": {
              "display_name": {},
            }
          },
          "scheduled_date": {},
          "date_done": {},
          "date_deadline": {},
          "origin": {},
        }
      },
      onResponse: (response) {
        if (response != null) {
          List<dynamic> records = [];

          if (response is List) {
            records = response;
          } else if (response is Map<String, dynamic> &&
              response.containsKey('records')) {
            records = response['records'];
          }

          for (var element in records) {
            if (element is Map<String, dynamic>) {
              stockPicking.add(StockPickingModel.fromJson(element));
            }
          }

          onResponse(stockPicking);
        } else {
          onResponse([]);
        }
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static webSave({
    required Map<String, dynamic> result,
    required OnResponse<int> onResponse,
  }) {
    Api.webSave(
      model: "stock.return.picking",
      args: [],
      value: result,
      onResponse: (response) {
        try {
          if (response is List<dynamic>) {
            if (response.isNotEmpty && response[0] is Map<String, dynamic>) {
              final id =
                  response[0]["id"]; // Extract the `id` from the first element
              onResponse(id); // Pass the `id` to the callback
            } else {
              throw Exception(
                  "Response list is empty or does not contain valid items.");
            }
          } else if (response is Map<String, dynamic>) {
            // Handle Map response (if applicable)
            final resultList = response["result"] as List<dynamic>;
            if (resultList.isNotEmpty) {
              final id = resultList[0]
                  ["id"]; // Extract the `id` from the first element
              onResponse(id);
            } else {
              throw Exception("Result list is empty.");
            }
          } else {
            throw Exception("Unexpected response type.");
          }
        } catch (e) {
          handleApiError(e); // Handle parsing or logic errors
        }
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static immediateTransfer(
      {required List<int> args, required OnResponse<dynamic> onResponse}) {
    Api.callKW(
        model: "stock.immediate.transfer",
        method: "process",
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static validateStockPicking(
      {Map<String, dynamic>? context,
      required List<int> args,
      required OnResponse onResponse}) {
    try {
      Api.callKW(
        model: "stock.picking",
        method: "button_validate",
        args: [args],
        context: context,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (String error, Map<String, dynamic> data) {
          handleApiError(error);
        },
      );
    } catch (e) {
      handleApiError(e);
    }
  }

  static stockBackorderConfirmation(
      {required String method,
      required List<int> args,
      required OnResponse<bool> onResponse}) {
    Api.callKW(
        model: "stock.backorder.confirmation",
        method: method,
        args: args,
        onResponse: (response) {
          onResponse(response);
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static onChangeReturnStock({
    required int id,
    required OnResponse<Map<String, dynamic>> onResponse,
  }) {
    Api.onChange(
      model: 'stock.return.picking',
      kwargs: {
        "context": {"active_model": "stock.picking", "active_id": id}
      },
      args: [
        [],
        {},
        [],
        {
          "picking_id": {"fields": {}},
          "company_id": {"fields": {}},
          "product_return_moves": {
            "fields": {
              "move_quantity": {},
              "product_id": {
                "fields": {"display_name": {}}
              },
              "quantity": {},
              "move_id": {"fields": {}},
              "to_refund": {}
            }
          }
        }
      ],
      onResponse: (response) {
        if (response != null && response is Map<String, dynamic>) {
          final value = response['value'];

          // استخراج البيانات المفيدة
          final pickingId = value['picking_id']?['id'];
          final companyId = value['company_id']?['id'];
          final productReturnMoves = value['product_return_moves'];

          // تجهيز البيانات المستخرجة وإرسالها
          final extractedData = {
            'pickingId': pickingId,
            'companyId': companyId,
            'productReturnMoves': productReturnMoves?.map((move) {
              final moveData = move[2];
              return {
                'move_quantity': moveData['move_quantity'],
                'product_id': moveData['product_id']?['id'],
                'product_name': moveData['product_id']?['display_name'],
                'quantity': moveData['quantity'],
                'move_id': moveData['move_id']?['id'],
                'to_refund': moveData['to_refund'],
              };
            }).toList(),
          };

          onResponse(extractedData);
        } else {
          onResponse({});
        }
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static returnStock(
      {required List<int> args, required OnResponse onResponse}) {
    Api.callKW(
      model: "stock.return.picking",
      method: "action_create_returns",
      args: args,
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static prinStockPickingPdfQR(
      {required OnResponse onResponse, required int id}) async {
    await Api.printReportPdf(
        reportName: 'stock.report_picking',
        recordId: id,
        onResponse: (response) async {
          final directory = await getDownloadsDirectory();
          final savePath = '${directory!.path}/picking_$id.pdf';
          final file = File(savePath);
          await file.writeAsBytes(response);
          onResponse(savePath);
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }

  static prinStockPickingPdf(
      {required OnResponse onResponse, required int id}) async {
    await Api.printReportPdf(
        reportName: 'stock.report_deliveryslip',
        recordId: id,
        onResponse: (response) async {
          final directory = await getDownloadsDirectory();
          final savePath = '${directory!.path}/picking_$id.pdf';
          final file = File(savePath);
          await file.writeAsBytes(response);
          onResponse(savePath);
        },
        onError: (e, d) {
          handleApiError(e);
        });
  }
}
