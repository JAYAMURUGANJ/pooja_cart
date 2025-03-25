// To parse this JSON data, do
//
//     final orderItems = orderItemsFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'order_items.g.dart';

OrderItems orderItemsFromJson(String str) =>
    OrderItems.fromJson(json.decode(str));

String orderItemsToJson(OrderItems data) => json.encode(data.toJson());

@JsonSerializable()
class OrderItems {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "unit_id")
  final int? unitId;

  OrderItems({this.id, this.name, this.unitId});

  factory OrderItems.fromJson(Map<String, dynamic> json) =>
      _$OrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}
