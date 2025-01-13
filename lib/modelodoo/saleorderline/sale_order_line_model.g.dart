

part of 'sale_order_line_model.dart';


SaleOrderLineModel _$SaleOrderLineModelFromJson(Map<String, dynamic> json) => SaleOrderLineModel(
orderId: json['order_id'] as dynamic,
name: json['name'] as dynamic,
productUomQty: json['product_uom_qty'] as dynamic,
priceUnit: json['price_unit'] as dynamic,
customerLead: json['customer_lead'] as dynamic,
);


Map<String, dynamic> _$SaleOrderLineModelToJson(SaleOrderLineModel instance) =>
<String, dynamic>{
'order_id': instance.orderId,
'name': instance.name,
'product_uom_qty': instance.productUomQty,
'price_unit': instance.priceUnit,
'customer_lead': instance.customerLead,
};
