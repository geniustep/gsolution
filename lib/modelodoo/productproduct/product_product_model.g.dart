

part of 'product_product_model.dart';


ProductProductModel _$ProductProductModelFromJson(Map<String, dynamic> json) => ProductProductModel(
image128: json['image_128'] as dynamic,
image256: json['image_256'] as dynamic,
qtyAvailable: json['qty_available'] as dynamic,
taxesId: json['taxes_id'] as dynamic,
lstPrice: json['lst_price'] as dynamic,
description: json['description'] as dynamic,
barcode: json['barcode'] as dynamic,
productTmplId: json['product_tmpl_id'] as dynamic,
name: json['name'] as dynamic,
type: json['type'] as dynamic,
serviceTracking: json['service_tracking'] as dynamic,
categId: json['categ_id'] as dynamic,
uomId: json['uom_id'] as dynamic,
uomPoId: json['uom_po_id'] as dynamic,
productVariantIds: json['product_variant_ids'] as dynamic,
tracking: json['tracking'] as dynamic,
purchaseLineWarn: json['purchase_line_warn'] as dynamic,
saleLineWarn: json['sale_line_warn'] as dynamic,
);


Map<String, dynamic> _$ProductProductModelToJson(ProductProductModel instance) =>
<String, dynamic>{
'image_128': instance.image128,
'image_256': instance.image256,
'qty_available': instance.qtyAvailable,
'taxes_id': instance.taxesId,
'lst_price': instance.lstPrice,
'description': instance.description,
'barcode': instance.barcode,
'product_tmpl_id': instance.productTmplId,
'name': instance.name,
'type': instance.type,
'service_tracking': instance.serviceTracking,
'categ_id': instance.categId,
'uom_id': instance.uomId,
'uom_po_id': instance.uomPoId,
'product_variant_ids': instance.productVariantIds,
'tracking': instance.tracking,
'purchase_line_warn': instance.purchaseLineWarn,
'sale_line_warn': instance.saleLineWarn,
};
