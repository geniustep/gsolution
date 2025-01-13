

part of 'sale_order_model.dart';


SaleOrderModel _$SaleOrderModelFromJson(Map<String, dynamic> json) => SaleOrderModel(
amountTotal: json['amount_total'] as dynamic,
state: json['state'] as dynamic,
activityIds: json['activity_ids'] as dynamic,
name: json['name'] as dynamic,
companyId: json['company_id'] as dynamic,
partnerId: json['partner_id'] as dynamic,
dateOrder: json['date_order'] as dynamic,
partnerInvoiceId: json['partner_invoice_id'] as dynamic,
partnerShippingId: json['partner_shipping_id'] as dynamic,
pickingPolicy: json['picking_policy'] as dynamic,
);


Map<String, dynamic> _$SaleOrderModelToJson(SaleOrderModel instance) =>
<String, dynamic>{
'amount_total': instance.amountTotal,
'state': instance.state,
'activity_ids': instance.activityIds,
'name': instance.name,
'company_id': instance.companyId,
'partner_id': instance.partnerId,
'date_order': instance.dateOrder,
'partner_invoice_id': instance.partnerInvoiceId,
'partner_shipping_id': instance.partnerShippingId,
'picking_policy': instance.pickingPolicy,
};
