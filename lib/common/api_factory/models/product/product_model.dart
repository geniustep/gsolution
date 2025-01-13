import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final dynamic id;
  final dynamic lstPrice;
  final dynamic active;
  final dynamic barcode;
  final dynamic isProductVariant;
  final dynamic standardPrice;
  final dynamic volume;
  final dynamic weight;
  final dynamic packagingIds;
  final dynamic image128;
  final dynamic image256;
  final dynamic image1920;
  final dynamic image512;
  final dynamic write_date;
  final dynamic display_name;
  final dynamic create_uid;
  final dynamic create_date;
  final dynamic write_uid;
  final dynamic description;
  final dynamic list_price;
  final dynamic name;
  final dynamic total_value;
  final dynamic sales_count;
  final dynamic categId;
  final dynamic qty_available;
  final dynamic virtual_available;
  final dynamic incoming_qty;
  final dynamic outgoing_qty;
  final dynamic product_tmpl_id;
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
    this.write_date,
    this.display_name,
    this.create_uid,
    this.create_date,
    this.write_uid,
    this.description,
    this.list_price,
    this.name,
    this.total_value,
    this.sales_count,
    this.categId,
    this.qty_available,
    this.virtual_available,
    this.incoming_qty,
    this.outgoing_qty,
    this.product_tmpl_id,
    this.image1920,
    this.image512,
    this.defaultCode,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
