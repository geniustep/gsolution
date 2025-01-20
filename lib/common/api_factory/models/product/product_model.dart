import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ProductModel {
  @JsonKey(name: 'id')
  @HiveField(0)
  final dynamic id;

  @JsonKey(name: 'lst_price')
  @HiveField(1)
  final dynamic lstPrice;

  @JsonKey(name: 'active')
  @HiveField(2)
  final dynamic active;

  @JsonKey(name: 'barcode')
  @HiveField(3)
  final dynamic barcode;

  @JsonKey(name: 'is_product_variant')
  @HiveField(4)
  final dynamic isProductVariant;

  @JsonKey(name: 'standard_price')
  @HiveField(5)
  final dynamic standardPrice;

  @JsonKey(name: 'volume')
  @HiveField(6)
  final dynamic volume;

  @JsonKey(name: 'weight')
  @HiveField(7)
  final dynamic weight;

  @JsonKey(name: 'packaging_ids')
  @HiveField(8)
  final dynamic packagingIds;

  @JsonKey(name: 'image_128')
  @HiveField(9)
  final dynamic image128;

  @JsonKey(name: 'image_256')
  @HiveField(10)
  final dynamic image256;

  @JsonKey(name: 'image_1920')
  @HiveField(11)
  final dynamic image1920;

  @JsonKey(name: 'image_512')
  @HiveField(12)
  final dynamic image512;

  @JsonKey(name: 'write_date')
  @HiveField(13)
  final dynamic writeDate;

  @JsonKey(name: 'display_name')
  @HiveField(14)
  final dynamic displayName;

  @JsonKey(name: 'create_uid')
  @HiveField(15)
  final dynamic createUid;

  @JsonKey(name: 'create_date')
  @HiveField(16)
  final dynamic createDate;

  @JsonKey(name: 'write_uid')
  @HiveField(17)
  final dynamic writeUid;

  @JsonKey(name: 'description')
  @HiveField(18)
  final dynamic description;

  @JsonKey(name: 'list_price')
  @HiveField(19)
  final dynamic listPrice;

  @JsonKey(name: 'name')
  @HiveField(20)
  final dynamic name;

  @JsonKey(name: 'total_value')
  @HiveField(21)
  final dynamic totalValue;

  @JsonKey(name: 'sales_count')
  @HiveField(22)
  final dynamic salesCount;

  @JsonKey(name: 'categ_id')
  @HiveField(23)
  final dynamic categId;

  @JsonKey(name: 'qty_available')
  @HiveField(24)
  final dynamic qtyAvailable;

  @JsonKey(name: 'virtual_available')
  @HiveField(25)
  final dynamic virtualAvailable;

  @JsonKey(name: 'incoming_qty')
  @HiveField(26)
  final dynamic incomingQty;

  @JsonKey(name: 'outgoing_qty')
  @HiveField(27)
  final dynamic outgoingQty;

  @JsonKey(name: 'product_tmpl_id')
  @HiveField(28)
  final dynamic productTmplId;

  @JsonKey(name: 'default_code')
  @HiveField(29)
  final dynamic defaultCode;

  ProductModel({
    this.id,
    this.lstPrice,
    this.active,
    this.barcode,
    this.isProductVariant,
    this.standardPrice,
    this.volume,
    this.weight,
    this.packagingIds,
    this.image128,
    this.image256,
    this.image1920,
    this.image512,
    this.writeDate,
    this.displayName,
    this.createUid,
    this.createDate,
    this.writeUid,
    this.description,
    this.listPrice,
    this.name,
    this.totalValue,
    this.salesCount,
    this.categId,
    this.qtyAvailable,
    this.virtualAvailable,
    this.incomingQty,
    this.outgoingQty,
    this.productTmplId,
    this.defaultCode,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
