// To parse this JSON data, do
//
//     final orderItems = orderItemsFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'order_items.g.dart';

OrderItems orderItemsFromJson(String str) =>
    OrderItems.fromJson(json.decode(str));

String orderItemsToJson(OrderItems data) => json.encode(data.toJson());

List orderItemsListToJson(List<OrderItems> data) =>
    data.map((e) => json.encode(e.toJson())).toList();

@JsonSerializable()
class OrderItems {
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "unit_id")
  final int? unitId;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "selling_price")
  int? sellingPrice;
  @JsonKey(name: "mrp")
  int? mrp;
  @JsonKey(name: "conversion_factor")
  int? conversionFactor;
  @JsonKey(name: "unit_abbreviation")
  String? unitAbbreviation;

  OrderItems({
    required this.productId,
    required this.name,
    required this.unitId,
    required this.quantity, // Initialize quantity
    required this.sellingPrice,
    required this.mrp,
    this.conversionFactor,
    this.unitAbbreviation,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) =>
      _$OrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}
