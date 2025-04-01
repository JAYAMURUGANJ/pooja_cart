import 'dart:convert';

import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';

PlaceOrderRequest placeOrderRequestFromJson(String str) =>
    PlaceOrderRequest.fromJson(json.decode(str));

String placeOrderRequestToJson(PlaceOrderRequest data) =>
    json.encode(data.toJson());

class PlaceOrderRequest {
  final ShippingDetails? shippingDetails;
  final List<OrderItems>? orderItems;
  final PaymentDetails? paymentDetails;
  final String? couponCode;
  final String? orderNotes;

  PlaceOrderRequest({
    this.shippingDetails,
    this.orderItems,
    this.paymentDetails,
    this.couponCode,
    this.orderNotes,
  });

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      PlaceOrderRequest(
        shippingDetails:
            json["shipping_details"] == null
                ? null
                : ShippingDetails.fromJson(json["shipping_details"]),
        orderItems:
            json["order_items"] == null
                ? []
                : List<OrderItems>.from(
                  json["order_items"]!.map((x) => OrderItems.fromJson(x)),
                ),
        paymentDetails:
            json["payment_details"] == null
                ? null
                : PaymentDetails.fromJson(json["payment_details"]),
        couponCode: json["coupon_code"],
        orderNotes: json["order_notes"],
      );

  Map<String, dynamic> toJson() => {
    if (shippingDetails != null) "shipping_details": shippingDetails!.toJson(),
    if (orderItems != null)
      "order_items": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    if (paymentDetails != null) "payment_details": paymentDetails!.toJson(),
    if (couponCode != null) "coupon_code": couponCode,
    if (orderNotes != null) "order_notes": orderNotes,
  };
}

class PaymentDetails {
  final String? paymentMethod;
  final String? transactionId;

  PaymentDetails({this.paymentMethod, this.transactionId});

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    paymentMethod: json["payment_method"],
    transactionId: json["transaction_id"],
  );

  Map<String, dynamic> toJson() => {
    if (paymentMethod != null) "payment_method": paymentMethod,
    if (transactionId != null) "transaction_id": transactionId,
  };
}

class ShippingDetails {
  final String? name;
  final String? mobileNo;
  final String? shippingAddress;
  final String? shippingMethod;

  ShippingDetails({
    this.name,
    this.mobileNo,
    this.shippingAddress,
    this.shippingMethod,
  });

  factory ShippingDetails.fromJson(Map<String, dynamic> json) =>
      ShippingDetails(
        name: json["name"],
        mobileNo: json["mobile_no"],
        shippingAddress: json["shipping_address"],
        shippingMethod: json["shipping_method"],
      );

  Map<String, dynamic> toJson() => {
    if (name != null) "name": name,
    if (mobileNo != null) "mobile_no": mobileNo,
    if (shippingAddress != null) "shipping_address": shippingAddress,
    if (shippingMethod != null) "shipping_method": shippingMethod,
  };
}
