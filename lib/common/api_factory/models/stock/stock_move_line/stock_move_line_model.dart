import 'package:json_annotation/json_annotation.dart';

part 'stock_move_line_model.g.dart';

@JsonSerializable()
class StockMoveLineModel {
  @JsonKey(name: 'picking_id')
  dynamic pickingId;
  @JsonKey(name: 'move_id')
  dynamic moveId;
  @JsonKey(name: 'company_id')
  dynamic companyId;
  @JsonKey(name: 'product_id')
  dynamic productId;
  @JsonKey(name: 'product_uom_id')
  dynamic productUomId;
  @JsonKey(name: 'product_qty')
  dynamic productQty;
  @JsonKey(name: 'product_uom_qty')
  dynamic productUomQty;
  @JsonKey(name: 'qty_done')
  dynamic qtyDone;
  @JsonKey(name: 'package_id')
  dynamic packageId;
  @JsonKey(name: 'package_level_id')
  dynamic packageLevelId;
  @JsonKey(name: 'lot_id')
  dynamic lotId;
  @JsonKey(name: 'lot_name')
  dynamic lotName;
  @JsonKey(name: 'result_package_id')
  dynamic resultPackageId;
  @JsonKey(name: 'date')
  dynamic date;
  @JsonKey(name: 'owner_id')
  dynamic ownerId;
  @JsonKey(name: 'location_id')
  dynamic locationId;
  @JsonKey(name: 'location_dest_id')
  dynamic locationDestId;
  @JsonKey(name: 'lots_visible')
  dynamic lotsVisible;
  @JsonKey(name: 'picking_code')
  dynamic pickingCode;
  @JsonKey(name: 'picking_type_use_create_lots')
  dynamic pickingTypeUseCreateLots;
  @JsonKey(name: 'picking_type_use_existing_lots')
  dynamic pickingTypeUseExistingLots;
  @JsonKey(name: 'state')
  dynamic state;
  @JsonKey(name: 'is_initial_demand_editable')
  dynamic isInitialDemandEditable;
  @JsonKey(name: 'is_locked')
  dynamic isLocked;
  @JsonKey(name: 'consume_line_ids')
  dynamic consumeLineIds;
  @JsonKey(name: 'produce_line_ids')
  dynamic produceLineIds;
  @JsonKey(name: 'reference')
  dynamic reference;
  @JsonKey(name: 'tracking')
  dynamic tracking;
  @JsonKey(name: 'origin')
  dynamic origin;
  @JsonKey(name: 'picking_type_entire_packs')
  dynamic pickingTypeEntirePacks;
  @JsonKey(name: 'description_picking')
  dynamic descriptionPicking;
  @JsonKey(name: 'id')
  dynamic id;
  @JsonKey(name: 'display_name')
  dynamic displayName;
  @JsonKey(name: 'create_uid')
  dynamic createUid;
  @JsonKey(name: 'create_date')
  dynamic createDate;
  @JsonKey(name: 'write_uid')
  dynamic writeUid;
  @JsonKey(name: 'write_date')
  dynamic writeDate;
  @JsonKey(name: '__last_update')
  dynamic lLastUpdate;

  StockMoveLineModel({
    this.pickingId,
    this.moveId,
    this.companyId,
    this.productId,
    this.productUomId,
    this.productQty,
    this.productUomQty,
    this.qtyDone,
    this.packageId,
    this.packageLevelId,
    this.lotId,
    this.lotName,
    this.resultPackageId,
    this.date,
    this.ownerId,
    this.locationId,
    this.locationDestId,
    this.lotsVisible,
    this.pickingCode,
    this.pickingTypeUseCreateLots,
    this.pickingTypeUseExistingLots,
    this.state,
    this.isInitialDemandEditable,
    this.isLocked,
    this.consumeLineIds,
    this.produceLineIds,
    this.reference,
    this.tracking,
    this.origin,
    this.pickingTypeEntirePacks,
    this.descriptionPicking,
    this.id,
    this.displayName,
    this.createUid,
    this.createDate,
    this.writeUid,
    this.writeDate,
    this.lLastUpdate,
  });

  factory StockMoveLineModel.fromJson(Map<String, dynamic> json) =>
      _$StockMoveLineModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockMoveLineModelToJson(this);
}
