// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'],
      lstPrice: json['lst_price'],
      active: json['active'],
      barcode: json['barcode'],
      isProductVariant: json['is_product_variant'],
      standardPrice: json['standard_price'],
      volume: json['volume'],
      weight: json['weight'],
      packagingIds: json['packaging_ids'],
      image128: json['image_128'],
      image256: json['image_256'],
      image1920: json['image_1920'],
      image512: json['image_512'],
      write_date: json['write_date'],
      display_name: json['display_name'],
      create_uid: json['create_uid'],
      create_date: json['create_date'],
      write_uid: json['write_uid'],
      description: json['description'],
      list_price: json['list_price'],
      name: json['name'],
      total_value: json['total_value'],
      sales_count: json['sales_count'],
      categId: json['categ_id'],
      product_tmpl_id: json['product_tmpl_id'],
      qty_available: json['qty_available'],
      defaultCode: json['default_code'],
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lst_price': instance.lstPrice,
      'active': instance.active,
      'barcode': instance.barcode,
      'is_product_variant': instance.isProductVariant,
      'standard_price': instance.standardPrice,
      'volume': instance.volume,
      'weight': instance.weight,
      'packaging_ids': instance.packagingIds,
      'image_128': instance.image128,
      'image_256': instance.image256,
      'image_1920': instance.image1920,
      'image_512': instance.image512,
      'write_date': instance.write_date,
      'display_name': instance.display_name,
      'create_uid': instance.create_uid,
      'create_date': instance.create_date,
      'write_uid': instance.write_uid,
      'description': instance.description,
      'list_price': instance.list_price,
      'name': instance.name,
      'total_value': instance.total_value,
      'sales_count': instance.sales_count,
      'categ_id': instance.categId,
      'product_tmpl_id': instance.product_tmpl_id,
      'qty_available': instance.qty_available,
      'default_code': instance.defaultCode,
    };
