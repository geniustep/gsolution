

import 'package:gsolution/common/config/import.dart';

class StockMoveLineModule {
  StockMoveLineModule._();

  static readStockMoveLine(
      {required List<int> ids,
      required OnResponse<List<StockMoveLineModel>> onResponse}) {
    List<String> fields = [
      "product_id",
      "company_id",
      "move_id",
      "picking_id",
      "location_id",
      "location_dest_id",
      "package_id",
      "result_package_id",
      "lots_visible",
      "owner_id",
      "state",
      "lot_id",
      "lot_name",
      "is_initial_demand_editable",
      "product_uom_qty",
      "is_locked",
      "qty_done",
      "product_uom_id"
    ];
    Api.read(
      model: "stock.move.line",
      ids: ids,
      fields: fields,
      onResponse: (response) {
        List<StockMoveLineModel> partners = [];
        for (var element in response) {
          partners.add(StockMoveLineModel.fromJson(element));
        }
        onResponse(partners);
      },
      onError: (error, data) {
        handleApiError(error);
      },
    );
  }

  static searchStockMoveLine(
      {int offset = 0,
      required OnResponse<Map<int, List<StockMoveLineModel>>> onResponse}) {
    List<String> fields = [
      "product_id",
      "company_id",
      "move_id",
      "picking_id",
      "location_id",
      "location_dest_id",
      "package_id",
      "result_package_id",
      "lots_visible",
      "owner_id",
      "state",
      "lot_id",
      "lot_name",
      "is_initial_demand_editable",
      "product_uom_qty",
      "is_locked",
      "qty_done",
      "product_uom_id"
    ];
    const int LIMIT = 60;
    List<StockMoveLineModel> partners = [];
    Api.searchRead(
        model: "stock.move.line",
        domain: [],
        limit: LIMIT,
        offset: offset,
        fields: fields,
        onResponse: (response) {
          if (response != null) {
            for (var element in response["records"]) {
              partners.add(StockMoveLineModel.fromJson(element));
            }
            onResponse({response["length"]: partners});
          }
        },
        onError: (error, data) {
          handleApiError(error);
        });
  }

  static UpdateStockPiching({
    required List<int> ids,
    required Map<String, dynamic>? maps,
    required OnResponse onResponse,
  }) {
  Module.writeModule(
      model: "stock.picking",
      ids: ids,
      values: maps!,
      onResponse: (response) {
        onResponse(response);
      },
    );
  }
}
