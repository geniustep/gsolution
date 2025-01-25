import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class PartnerModel {
  @JsonKey(name: 'id')
  @HiveField(0)
  dynamic id;

  @JsonKey(name: 'same_vat_partner_id')
  @HiveField(1)
  dynamic sameVatPartnerId;

  @JsonKey(name: 'partner_gid')
  @HiveField(2)
  dynamic partnerGid;

  @JsonKey(name: 'additional_info')
  @HiveField(4)
  dynamic additionalInfo;

  @JsonKey(name: 'sale_order_count')
  @HiveField(5)
  dynamic saleOrderCount;

  @JsonKey(name: 'total_invoiced')
  @HiveField(6)
  dynamic totalInvoiced;

  @JsonKey(name: 'payment_token_count')
  @HiveField(7)
  dynamic paymentTokenCount;

  @JsonKey(name: 'image_512')
  @HiveField(8)
  dynamic image_512;

  @JsonKey(name: 'image_256')
  @HiveField(9)
  dynamic image_256;

  @JsonKey(name: 'image_1920')
  @HiveField(10)
  dynamic image1920;

  @JsonKey(name: 'image_128')
  @HiveField(11)
  dynamic image_128;

  @JsonKey(name: '__last_update')
  @HiveField(12)
  dynamic sLastUpdate;

  @JsonKey(name: 'is_company')
  @HiveField(13)
  bool? isCompany;

  @JsonKey(name: 'commercial_partner_id')
  @HiveField(14)
  dynamic commercialPartnerId;

  @JsonKey(name: 'active')
  @HiveField(15)
  dynamic active;

  @JsonKey(name: 'company_type')
  @HiveField(16)
  dynamic companyType;

  @JsonKey(name: 'name')
  @HiveField(17)
  dynamic name;

  @JsonKey(name: 'parent_id')
  @HiveField(18)
  dynamic parentId;

  @JsonKey(name: 'company_name')
  @HiveField(19)
  dynamic companyName;

  @JsonKey(name: 'type')
  @HiveField(20)
  dynamic type;

  @JsonKey(name: 'street')
  @HiveField(21)
  dynamic street;

  @JsonKey(name: 'street2')
  @HiveField(22)
  dynamic street2;

  @JsonKey(name: 'city')
  @HiveField(23)
  dynamic city;

  @JsonKey(name: 'state_id')
  @HiveField(24)
  dynamic stateId;

  @JsonKey(name: 'zip')
  @HiveField(25)
  dynamic zip;

  @JsonKey(name: 'country_id')
  @HiveField(26)
  dynamic countryId;

  @JsonKey(name: 'vat')
  @HiveField(27)
  dynamic vat;

  @JsonKey(name: 'function')
  @HiveField(28)
  dynamic function;

  @JsonKey(name: 'phone')
  @HiveField(29)
  dynamic phone;

  @JsonKey(name: 'mobile')
  @HiveField(30)
  dynamic mobile;

  @JsonKey(name: 'email')
  @HiveField(31)
  dynamic email;

  @JsonKey(name: 'website')
  @HiveField(32)
  dynamic website;

  @JsonKey(name: 'display_name')
  @HiveField(33)
  dynamic displayName;

  @JsonKey(name: 'customer_rank')
  @HiveField(34)
  dynamic customerRank;

  @JsonKey(name: 'partner_latitude')
  @HiveField(35)
  dynamic partnerLatitude;

  @JsonKey(name: 'partner_longitude')
  @HiveField(36)
  dynamic partnerLongitude;

  @JsonKey(name: 'child_ids')
  @HiveField(37)
  dynamic childIds;

  @HiveField(38)
  int hiveWriteDate;

  PartnerModel({
    this.id,
    this.sameVatPartnerId,
    this.partnerGid,
    this.hiveWriteDate = 0,
    this.additionalInfo,
    this.saleOrderCount,
    this.totalInvoiced,
    this.paymentTokenCount,
    this.image1920,
    this.image_128,
    this.image_512,
    this.image_256,
    this.sLastUpdate,
    this.isCompany,
    this.commercialPartnerId,
    this.active,
    this.companyType,
    this.name,
    this.parentId,
    this.companyName,
    this.type,
    this.street,
    this.street2,
    this.city,
    this.stateId,
    this.zip,
    this.countryId,
    this.vat,
    this.function,
    this.phone,
    this.mobile,
    this.email,
    this.website,
    this.displayName,
    this.customerRank,
    this.partnerLatitude,
    this.partnerLongitude,
    this.childIds,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return _$PartnerModelFromJson(json)
      ..hiveWriteDate = DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() => _$PartnerModelToJson(this);
}
