import 'package:json_annotation/json_annotation.dart';

part 'product_product_model.g.dart';

@JsonSerializable()
class ProductProductModel {
  final dynamic image128;
  final dynamic image256;
  final dynamic qtyAvailable;
  final dynamic taxesId;
  final dynamic lstPrice;
  final dynamic description;
  final dynamic barcode;
  final dynamic productTmplId;
  final dynamic name;
  final dynamic type;
  final dynamic serviceTracking;
  final dynamic categId;
  final dynamic uomId;
  final dynamic uomPoId;
  final dynamic productVariantIds;
  final dynamic tracking;
  final dynamic purchaseLineWarn;
  final dynamic saleLineWarn;

  ProductProductModel({
    required this.image128,
    required this.image256,
    required this.qtyAvailable,
    required this.taxesId,
    required this.lstPrice,
    required this.description,
    required this.barcode,
    required this.productTmplId,
    required this.name,
    required this.type,
    required this.serviceTracking,
    required this.categId,
    required this.uomId,
    required this.uomPoId,
    required this.productVariantIds,
    required this.tracking,
    required this.purchaseLineWarn,
    required this.saleLineWarn,
  });

  factory ProductProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductProductModelToJson(this);
}
