// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_order_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleOrderLineModel _$SaleOrderLineModelFromJson(Map<String, dynamic> json) =>
    SaleOrderLineModel(
      orderId: json['orderId'],
      name: json['name'],
      productUomQty: json['productUomQty'],
      priceUnit: json['priceUnit'],
      customerLead: json['customerLead'],
    );

Map<String, dynamic> _$SaleOrderLineModelToJson(SaleOrderLineModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'name': instance.name,
      'productUomQty': instance.productUomQty,
      'priceUnit': instance.priceUnit,
      'customerLead': instance.customerLead,
    };
