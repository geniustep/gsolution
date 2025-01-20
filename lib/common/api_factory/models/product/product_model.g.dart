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
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(30)
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
      ..write(obj.defaultCode);
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
    };
