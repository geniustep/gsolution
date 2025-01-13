import 'package:json_annotation/json_annotation.dart';

part 'sale_order_model.g.dart';

@JsonSerializable()
class SaleOrderModel {
  final dynamic amountTotal;
  final dynamic state;
  final dynamic activityIds;
  final dynamic name;
  final dynamic companyId;
  final dynamic partnerId;
  final dynamic dateOrder;
  final dynamic partnerInvoiceId;
  final dynamic partnerShippingId;
  final dynamic pickingPolicy;

  SaleOrderModel({
    required this.amountTotal,
    required this.state,
    required this.activityIds,
    required this.name,
    required this.companyId,
    required this.partnerId,
    required this.dateOrder,
    required this.partnerInvoiceId,
    required this.partnerShippingId,
    required this.pickingPolicy,
  });

  factory SaleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleOrderModelToJson(this);
}
