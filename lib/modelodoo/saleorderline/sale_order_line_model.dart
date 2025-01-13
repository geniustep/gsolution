import 'package:json_annotation/json_annotation.dart';

part 'sale_order_line_model.g.dart';

@JsonSerializable()
class SaleOrderLineModel {
  final dynamic orderId;
  final dynamic name;
  final dynamic productUomQty;
  final dynamic priceUnit;
  final dynamic customerLead;

  SaleOrderLineModel({
    required this.orderId,
    required this.name,
    required this.productUomQty,
    required this.priceUnit,
    required this.customerLead,
  });

  factory SaleOrderLineModel.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderLineModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaleOrderLineModelToJson(this);
}
