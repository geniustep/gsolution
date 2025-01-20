// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductProductModel _$ProductProductModelFromJson(Map<String, dynamic> json) =>
    ProductProductModel(
      image128: json['image128'],
      image256: json['image256'],
      qtyAvailable: json['qtyAvailable'],
      taxesId: json['taxesId'],
      lstPrice: json['lstPrice'],
      description: json['description'],
      barcode: json['barcode'],
      productTmplId: json['productTmplId'],
      name: json['name'],
      type: json['type'],
      serviceTracking: json['serviceTracking'],
      categId: json['categId'],
      uomId: json['uomId'],
      uomPoId: json['uomPoId'],
      productVariantIds: json['productVariantIds'],
      tracking: json['tracking'],
      purchaseLineWarn: json['purchaseLineWarn'],
      saleLineWarn: json['saleLineWarn'],
    );

Map<String, dynamic> _$ProductProductModelToJson(
        ProductProductModel instance) =>
    <String, dynamic>{
      'image128': instance.image128,
      'image256': instance.image256,
      'qtyAvailable': instance.qtyAvailable,
      'taxesId': instance.taxesId,
      'lstPrice': instance.lstPrice,
      'description': instance.description,
      'barcode': instance.barcode,
      'productTmplId': instance.productTmplId,
      'name': instance.name,
      'type': instance.type,
      'serviceTracking': instance.serviceTracking,
      'categId': instance.categId,
      'uomId': instance.uomId,
      'uomPoId': instance.uomPoId,
      'productVariantIds': instance.productVariantIds,
      'tracking': instance.tracking,
      'purchaseLineWarn': instance.purchaseLineWarn,
      'saleLineWarn': instance.saleLineWarn,
    };
