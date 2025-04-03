// To parse this JSON data, do
//
//     final myOrdersResponse = myOrdersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'my_orders_response.g.dart';

List<MyOrdersResponse> myOrdersResponseFromJson(String str) =>
    List<MyOrdersResponse>.from(
      json.decode(str).map((x) => MyOrdersResponse.fromJson(x)),
    );

String myOrdersResponseToJson(List<MyOrdersResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class MyOrdersResponse {
  @JsonKey(name: "order_id")
  final int? orderId;
  @JsonKey(name: "order_date")
  final DateTime? orderDate;
  @JsonKey(name: "order_status")
  final String? orderStatus;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "mobile_no")
  final String? mobileNo;
  @JsonKey(name: "email")
  final dynamic email;
  @JsonKey(name: "shipping_address")
  final String? shippingAddress;
  @JsonKey(name: "shipping_method")
  final String? shippingMethod;
  @JsonKey(name: "sub_total")
  final double? subTotal;
  @JsonKey(name: "discount")
  final double? discount;
  @JsonKey(name: "shipping_cost")
  final double? shippingCost;
  @JsonKey(name: "tax")
  final double? tax;
  @JsonKey(name: "total")
  final double? total;
  @JsonKey(name: "payment_method")
  final String? paymentMethod;
  @JsonKey(name: "transaction_id")
  final String? transactionId;
  @JsonKey(name: "coupon_code")
  final String? couponCode;
  @JsonKey(name: "order_notes")
  final String? orderNotes;
  @JsonKey(name: "order_reference")
  final String? orderReference;
  @JsonKey(name: "order_items")
  final List<OrderItem>? orderItems;
  @JsonKey(name: "status_history")
  final List<StatusHistory>? statusHistory;

  MyOrdersResponse({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.name,
    this.mobileNo,
    this.email,
    this.shippingAddress,
    this.shippingMethod,
    this.subTotal,
    this.discount,
    this.shippingCost,
    this.tax,
    this.total,
    this.paymentMethod,
    this.transactionId,
    this.couponCode,
    this.orderNotes,
    this.orderReference,
    this.orderItems,
    this.statusHistory,
  });

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$MyOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrdersResponseToJson(this);
}

@JsonSerializable()
class OrderItem {
  @JsonKey(name: "order_item_id")
  final int? orderItemId;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "unit_id")
  final int? unitId;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "selling_price")
  final double? sellingPrice;
  @JsonKey(name: "mrp")
  final int? mrp;
  @JsonKey(name: "item_sub_total")
  final double? itemSubTotal;
  @JsonKey(name: "item_discount")
  final double? itemDiscount;
  @JsonKey(name: "product_name")
  final String? productName;
  @JsonKey(name: "product_description")
  final String? productDescription;
  @JsonKey(name: "unit_name")
  final String? unitName;
  @JsonKey(name: "unit_abbreviation")
  final String? unitAbbreviation;
  @JsonKey(name: "product_image")
  final String? productImage;

  OrderItem({
    this.orderItemId,
    this.productId,
    this.unitId,
    this.quantity,
    this.sellingPrice,
    this.mrp,
    this.itemSubTotal,
    this.itemDiscount,
    this.productName,
    this.productDescription,
    this.unitName,
    this.unitAbbreviation,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class StatusHistory {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "status_description")
  final String? statusDescription;
  @JsonKey(name: "created_at")
  final DateTime? createdAt;

  StatusHistory({this.status, this.statusDescription, this.createdAt});

  factory StatusHistory.fromJson(Map<String, dynamic> json) =>
      _$StatusHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$StatusHistoryToJson(this);
}
