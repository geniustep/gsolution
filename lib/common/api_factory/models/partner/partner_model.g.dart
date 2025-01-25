// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartnerModelAdapter extends TypeAdapter<PartnerModel> {
  @override
  final int typeId = 2;

  @override
  PartnerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartnerModel(
      id: fields[0] as dynamic,
      sameVatPartnerId: fields[1] as dynamic,
      partnerGid: fields[2] as dynamic,
      hiveWriteDate: fields[38] as int,
      additionalInfo: fields[4] as dynamic,
      saleOrderCount: fields[5] as dynamic,
      totalInvoiced: fields[6] as dynamic,
      paymentTokenCount: fields[7] as dynamic,
      image1920: fields[10] as dynamic,
      image_128: fields[11] as dynamic,
      image_512: fields[8] as dynamic,
      image_256: fields[9] as dynamic,
      sLastUpdate: fields[12] as dynamic,
      isCompany: fields[13] as bool?,
      commercialPartnerId: fields[14] as dynamic,
      active: fields[15] as dynamic,
      companyType: fields[16] as dynamic,
      name: fields[17] as dynamic,
      parentId: fields[18] as dynamic,
      companyName: fields[19] as dynamic,
      type: fields[20] as dynamic,
      street: fields[21] as dynamic,
      street2: fields[22] as dynamic,
      city: fields[23] as dynamic,
      stateId: fields[24] as dynamic,
      zip: fields[25] as dynamic,
      countryId: fields[26] as dynamic,
      vat: fields[27] as dynamic,
      function: fields[28] as dynamic,
      phone: fields[29] as dynamic,
      mobile: fields[30] as dynamic,
      email: fields[31] as dynamic,
      website: fields[32] as dynamic,
      displayName: fields[33] as dynamic,
      customerRank: fields[34] as dynamic,
      partnerLatitude: fields[35] as dynamic,
      partnerLongitude: fields[36] as dynamic,
      childIds: fields[37] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, PartnerModel obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sameVatPartnerId)
      ..writeByte(2)
      ..write(obj.partnerGid)
      ..writeByte(4)
      ..write(obj.additionalInfo)
      ..writeByte(5)
      ..write(obj.saleOrderCount)
      ..writeByte(6)
      ..write(obj.totalInvoiced)
      ..writeByte(7)
      ..write(obj.paymentTokenCount)
      ..writeByte(8)
      ..write(obj.image_512)
      ..writeByte(9)
      ..write(obj.image_256)
      ..writeByte(10)
      ..write(obj.image1920)
      ..writeByte(11)
      ..write(obj.image_128)
      ..writeByte(12)
      ..write(obj.sLastUpdate)
      ..writeByte(13)
      ..write(obj.isCompany)
      ..writeByte(14)
      ..write(obj.commercialPartnerId)
      ..writeByte(15)
      ..write(obj.active)
      ..writeByte(16)
      ..write(obj.companyType)
      ..writeByte(17)
      ..write(obj.name)
      ..writeByte(18)
      ..write(obj.parentId)
      ..writeByte(19)
      ..write(obj.companyName)
      ..writeByte(20)
      ..write(obj.type)
      ..writeByte(21)
      ..write(obj.street)
      ..writeByte(22)
      ..write(obj.street2)
      ..writeByte(23)
      ..write(obj.city)
      ..writeByte(24)
      ..write(obj.stateId)
      ..writeByte(25)
      ..write(obj.zip)
      ..writeByte(26)
      ..write(obj.countryId)
      ..writeByte(27)
      ..write(obj.vat)
      ..writeByte(28)
      ..write(obj.function)
      ..writeByte(29)
      ..write(obj.phone)
      ..writeByte(30)
      ..write(obj.mobile)
      ..writeByte(31)
      ..write(obj.email)
      ..writeByte(32)
      ..write(obj.website)
      ..writeByte(33)
      ..write(obj.displayName)
      ..writeByte(34)
      ..write(obj.customerRank)
      ..writeByte(35)
      ..write(obj.partnerLatitude)
      ..writeByte(36)
      ..write(obj.partnerLongitude)
      ..writeByte(37)
      ..write(obj.childIds)
      ..writeByte(38)
      ..write(obj.hiveWriteDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerModel _$PartnerModelFromJson(Map<String, dynamic> json) => PartnerModel(
      id: json['id'],
      sameVatPartnerId: json['same_vat_partner_id'],
      partnerGid: json['partner_gid'],
      hiveWriteDate: (json['hiveWriteDate'] as num?)?.toInt() ?? 0,
      additionalInfo: json['additional_info'],
      saleOrderCount: json['sale_order_count'],
      totalInvoiced: json['total_invoiced'],
      paymentTokenCount: json['payment_token_count'],
      image1920: json['image_1920'],
      image_128: json['image_128'],
      image_512: json['image_512'],
      image_256: json['image_256'],
      sLastUpdate: json['__last_update'],
      isCompany: json['is_company'] as bool?,
      commercialPartnerId: json['commercial_partner_id'],
      active: json['active'],
      companyType: json['company_type'],
      name: json['name'],
      parentId: json['parent_id'],
      companyName: json['company_name'],
      type: json['type'],
      street: json['street'],
      street2: json['street2'],
      city: json['city'],
      stateId: json['state_id'],
      zip: json['zip'],
      countryId: json['country_id'],
      vat: json['vat'],
      function: json['function'],
      phone: json['phone'],
      mobile: json['mobile'],
      email: json['email'],
      website: json['website'],
      displayName: json['display_name'],
      customerRank: json['customer_rank'],
      partnerLatitude: json['partner_latitude'],
      partnerLongitude: json['partner_longitude'],
      childIds: json['child_ids'],
    );

Map<String, dynamic> _$PartnerModelToJson(PartnerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'same_vat_partner_id': instance.sameVatPartnerId,
      'partner_gid': instance.partnerGid,
      'additional_info': instance.additionalInfo,
      'sale_order_count': instance.saleOrderCount,
      'total_invoiced': instance.totalInvoiced,
      'payment_token_count': instance.paymentTokenCount,
      'image_512': instance.image_512,
      'image_256': instance.image_256,
      'image_1920': instance.image1920,
      'image_128': instance.image_128,
      '__last_update': instance.sLastUpdate,
      'is_company': instance.isCompany,
      'commercial_partner_id': instance.commercialPartnerId,
      'active': instance.active,
      'company_type': instance.companyType,
      'name': instance.name,
      'parent_id': instance.parentId,
      'company_name': instance.companyName,
      'type': instance.type,
      'street': instance.street,
      'street2': instance.street2,
      'city': instance.city,
      'state_id': instance.stateId,
      'zip': instance.zip,
      'country_id': instance.countryId,
      'vat': instance.vat,
      'function': instance.function,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'email': instance.email,
      'website': instance.website,
      'display_name': instance.displayName,
      'customer_rank': instance.customerRank,
      'partner_latitude': instance.partnerLatitude,
      'partner_longitude': instance.partnerLongitude,
      'child_ids': instance.childIds,
      'hiveWriteDate': instance.hiveWriteDate,
    };
