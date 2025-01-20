// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleOrderModel _$SaleOrderModelFromJson(Map<String, dynamic> json) =>
    SaleOrderModel(
      amountTotal: json['amountTotal'],
      state: json['state'],
      activityIds: json['activityIds'],
      name: json['name'],
      companyId: json['companyId'],
      partnerId: json['partnerId'],
      dateOrder: json['dateOrder'],
      partnerInvoiceId: json['partnerInvoiceId'],
      partnerShippingId: json['partnerShippingId'],
      pickingPolicy: json['pickingPolicy'],
    );

Map<String, dynamic> _$SaleOrderModelToJson(SaleOrderModel instance) =>
    <String, dynamic>{
      'amountTotal': instance.amountTotal,
      'state': instance.state,
      'activityIds': instance.activityIds,
      'name': instance.name,
      'companyId': instance.companyId,
      'partnerId': instance.partnerId,
      'dateOrder': instance.dateOrder,
      'partnerInvoiceId': instance.partnerInvoiceId,
      'partnerShippingId': instance.partnerShippingId,
      'pickingPolicy': instance.pickingPolicy,
    };
