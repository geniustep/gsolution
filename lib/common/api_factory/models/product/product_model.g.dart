// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as dynamic,
      lstPrice: fields[1] as dynamic,
      active: fields[2] as dynamic,
      barcode: fields[3] as dynamic,
      isProductVariant: fields[4] as dynamic,
      standardPrice: fields[5] as dynamic,
      volume: fields[6] as dynamic,
      weight: fields[7] as dynamic,
      packagingIds: fields[8] as dynamic,
      image128: fields[9] as dynamic,
      image256: fields[10] as dynamic,
      image1920: fields[11] as dynamic,
      image512: fields[12] as dynamic,
      writeDate: fields[13] as dynamic,
      displayName: fields[14] as dynamic,
      createUid: fields[15] as dynamic,
      createDate: fields[16] as dynamic,
      writeUid: fields[17] as dynamic,
      description: fields[18] as dynamic,
      listPrice: fields[19] as dynamic,
      name: fields[20] as dynamic,
      totalValue: fields[21] as dynamic,
      salesCount: fields[22] as dynamic,
      categId: fields[23] as dynamic,
      qtyAvailable: fields[24] as dynamic,
      virtualAvailable: fields[25] as dynamic,
      incomingQty: fields[26] as dynamic,
      outgoingQty: fields[27] as dynamic,
      productTmplId: fields[28] as dynamic,
      defaultCode: fields[29] as dynamic,
      taxesId: fields[30] as dynamic,
      supplierTaxesId: fields[31] as dynamic,
      type: fields[32] as dynamic,
      uomId: fields[33] as dynamic,
      uomPoId: fields[34] as dynamic,
      tracking: fields[35] as dynamic,
      saleOk: fields[36] as dynamic,
      purchaseOk: fields[37] as dynamic,
      companyId: fields[38] as dynamic,
      routeIds: fields[39] as dynamic,
      orderpointIds: fields[40] as dynamic,
      propertyAccountIncomeId: fields[41] as dynamic,
      propertyAccountExpenseId: fields[42] as dynamic,
      barcodeNomenclatureId: fields[43] as dynamic,
      salesCountLastMonth: fields[44] as dynamic,
      salesCountLastYear: fields[45] as dynamic,
      hiveWriteDate: fields[46] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(47)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lstPrice)
      ..writeByte(2)
      ..write(obj.active)
      ..writeByte(3)
      ..write(obj.barcode)
      ..writeByte(4)
      ..write(obj.isProductVariant)
      ..writeByte(5)
      ..write(obj.standardPrice)
      ..writeByte(6)
      ..write(obj.volume)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.packagingIds)
      ..writeByte(9)
      ..write(obj.image128)
      ..writeByte(10)
      ..write(obj.image256)
      ..writeByte(11)
      ..write(obj.image1920)
      ..writeByte(12)
      ..write(obj.image512)
      ..writeByte(13)
      ..write(obj.writeDate)
      ..writeByte(14)
      ..write(obj.displayName)
      ..writeByte(15)
      ..write(obj.createUid)
      ..writeByte(16)
      ..write(obj.createDate)
      ..writeByte(17)
      ..write(obj.writeUid)
      ..writeByte(18)
      ..write(obj.description)
      ..writeByte(19)
      ..write(obj.listPrice)
      ..writeByte(20)
      ..write(obj.name)
      ..writeByte(21)
      ..write(obj.totalValue)
      ..writeByte(22)
      ..write(obj.salesCount)
      ..writeByte(23)
      ..write(obj.categId)
      ..writeByte(24)
      ..write(obj.qtyAvailable)
      ..writeByte(25)
      ..write(obj.virtualAvailable)
      ..writeByte(26)
      ..write(obj.incomingQty)
      ..writeByte(27)
      ..write(obj.outgoingQty)
      ..writeByte(28)
      ..write(obj.productTmplId)
      ..writeByte(29)
      ..write(obj.defaultCode)
      ..writeByte(30)
      ..write(obj.taxesId)
      ..writeByte(31)
      ..write(obj.supplierTaxesId)
      ..writeByte(32)
      ..write(obj.type)
      ..writeByte(33)
      ..write(obj.uomId)
      ..writeByte(34)
      ..write(obj.uomPoId)
      ..writeByte(35)
      ..write(obj.tracking)
      ..writeByte(36)
      ..write(obj.saleOk)
      ..writeByte(37)
      ..write(obj.purchaseOk)
      ..writeByte(38)
      ..write(obj.companyId)
      ..writeByte(39)
      ..write(obj.routeIds)
      ..writeByte(40)
      ..write(obj.orderpointIds)
      ..writeByte(41)
      ..write(obj.propertyAccountIncomeId)
      ..writeByte(42)
      ..write(obj.propertyAccountExpenseId)
      ..writeByte(43)
      ..write(obj.barcodeNomenclatureId)
      ..writeByte(44)
      ..write(obj.salesCountLastMonth)
      ..writeByte(45)
      ..write(obj.salesCountLastYear)
      ..writeByte(46)
      ..write(obj.hiveWriteDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      writeDate: json['write_date'],
      displayName: json['display_name'],
      createUid: json['create_uid'],
      createDate: json['create_date'],
      writeUid: json['write_uid'],
      description: json['description'],
      listPrice: json['list_price'],
      name: json['name'],
      totalValue: json['total_value'],
      salesCount: json['sales_count'],
      categId: json['categ_id'],
      qtyAvailable: json['qty_available'],
      virtualAvailable: json['virtual_available'],
      incomingQty: json['incoming_qty'],
      outgoingQty: json['outgoing_qty'],
      productTmplId: json['product_tmpl_id'],
      defaultCode: json['default_code'],
      taxesId: json['taxes_id'],
      supplierTaxesId: json['supplier_taxes_id'],
      type: json['type'],
      uomId: json['uom_id'],
      uomPoId: json['uom_po_id'],
      tracking: json['tracking'],
      saleOk: json['sale_ok'],
      purchaseOk: json['purchase_ok'],
      companyId: json['company_id'],
      routeIds: json['route_ids'],
      orderpointIds: json['orderpoint_ids'],
      propertyAccountIncomeId: json['property_account_income_id'],
      propertyAccountExpenseId: json['property_account_expense_id'],
      barcodeNomenclatureId: json['barcode_nomenclature_id'],
      salesCountLastMonth: json['sales_count_last_month'],
      salesCountLastYear: json['sales_count_last_year'],
      hiveWriteDate: json['hiveWriteDate'],
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
      'write_date': instance.writeDate,
      'display_name': instance.displayName,
      'create_uid': instance.createUid,
      'create_date': instance.createDate,
      'write_uid': instance.writeUid,
      'description': instance.description,
      'list_price': instance.listPrice,
      'name': instance.name,
      'total_value': instance.totalValue,
      'sales_count': instance.salesCount,
      'categ_id': instance.categId,
      'qty_available': instance.qtyAvailable,
      'virtual_available': instance.virtualAvailable,
      'incoming_qty': instance.incomingQty,
      'outgoing_qty': instance.outgoingQty,
      'product_tmpl_id': instance.productTmplId,
      'default_code': instance.defaultCode,
      'taxes_id': instance.taxesId,
      'supplier_taxes_id': instance.supplierTaxesId,
      'type': instance.type,
      'uom_id': instance.uomId,
      'uom_po_id': instance.uomPoId,
      'tracking': instance.tracking,
      'sale_ok': instance.saleOk,
      'purchase_ok': instance.purchaseOk,
      'company_id': instance.companyId,
      'route_ids': instance.routeIds,
      'orderpoint_ids': instance.orderpointIds,
      'property_account_income_id': instance.propertyAccountIncomeId,
      'property_account_expense_id': instance.propertyAccountExpenseId,
      'barcode_nomenclature_id': instance.barcodeNomenclatureId,
      'sales_count_last_month': instance.salesCountLastMonth,
      'sales_count_last_year': instance.salesCountLastYear,
      'hiveWriteDate': instance.hiveWriteDate,
    };
