// To parse this JSON data, do
//
//     final placeOrderResponse = placeOrderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'place_order_response.g.dart';

PlaceOrderResponse placeOrderResponseFromJson(String str) =>
    PlaceOrderResponse.fromJson(json.decode(str));

String placeOrderResponseToJson(PlaceOrderResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class PlaceOrderResponse {
  @JsonKey(name: "order_id")
  final int? orderId;
  @JsonKey(name: "order_reference")
  final String? orderReference;
  @JsonKey(name: "order_date")
  final DateTime? orderDate;
  @JsonKey(name: "order_status")
  final String? orderStatus;
  @JsonKey(name: "shipping_details")
  final ShippingDetails? shippingDetails;
  @JsonKey(name: "order_items")
  final List<PlacedOrderItem>? orderItems;
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
  @JsonKey(name: "payment_details")
  final PaymentDetails? paymentDetails;
  @JsonKey(name: "coupon_code")
  final String? couponCode;
  @JsonKey(name: "order_notes")
  final String? orderNotes;
  @JsonKey(name: "status_history")
  final List<StatusHistory>? statusHistory;

  PlaceOrderResponse({
    this.orderId,
    this.orderReference,
    this.orderDate,
    this.orderStatus,
    this.shippingDetails,
    this.orderItems,
    this.subTotal,
    this.discount,
    this.shippingCost,
    this.tax,
    this.total,
    this.paymentDetails,
    this.couponCode,
    this.orderNotes,
    this.statusHistory,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceOrderResponseToJson(this);
}

@JsonSerializable()
class PlacedOrderItem {
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

  PlacedOrderItem({
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

  factory PlacedOrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class PaymentDetails {
  @JsonKey(name: "payment_method")
  final String? paymentMethod;
  @JsonKey(name: "transaction_id")
  final String? transactionId;

  PaymentDetails({this.paymentMethod, this.transactionId});

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);
}

@JsonSerializable()
class ShippingDetails {
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

  ShippingDetails({
    this.name,
    this.mobileNo,
    this.email,
    this.shippingAddress,
    this.shippingMethod,
  });

  factory ShippingDetails.fromJson(Map<String, dynamic> json) =>
      _$ShippingDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingDetailsToJson(this);
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
