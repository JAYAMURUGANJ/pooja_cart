// To parse this JSON data, do
//
//     final placeOrderResponseModel = placeOrderResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pooja_cart/features/domain/entities/place_order/place_order_response.dart';

PlaceOrderResponseModel placeOrderResponseModelFromJson(String str) =>
    PlaceOrderResponseModel.fromJson(json.decode(str));

String placeOrderResponseModelToJson(PlaceOrderResponseModel data) =>
    json.encode(data.toJson());

class PlaceOrderResponseModel extends PlaceOrderResponse {
  PlaceOrderResponseModel({
    required super.orderId,
    required super.orderReference,
    required super.orderDate,
    required super.orderStatus,
    required super.shippingDetails,
    required super.orderItems,
    required super.subTotal,
    required super.discount,
    required super.shippingCost,
    required super.tax,
    required super.total,
    required super.paymentDetails,
    required super.couponCode,
    required super.orderNotes,
    required super.statusHistory,
  });

  factory PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      PlaceOrderResponseModel(
        orderId: json["order_id"],
        orderReference: json["order_reference"],
        orderDate:
            json["order_date"] == null
                ? null
                : DateTime.parse(json["order_date"]),
        orderStatus: json["order_status"],
        shippingDetails:
            json["shipping_details"] == null
                ? null
                : ShippingDetails.fromJson(json["shipping_details"]),
        orderItems:
            json["order_items"] == null
                ? []
                : List<OrderItem>.from(
                  json["order_items"]!.map((x) => OrderItem.fromJson(x)),
                ),
        subTotal: json["sub_total"]?.toDouble(),
        discount: json["discount"]?.toDouble(),
        shippingCost: json["shipping_cost"]?.toDouble(),
        tax: json["tax"]?.toDouble(),
        total: json["total"]?.toDouble(),
        paymentDetails:
            json["payment_details"] == null
                ? null
                : PaymentDetails.fromJson(json["payment_details"]),
        couponCode: json["coupon_code"],
        orderNotes: json["order_notes"],
        statusHistory:
            json["status_history"] == null
                ? []
                : List<StatusHistory>.from(
                  json["status_history"]!.map((x) => StatusHistory.fromJson(x)),
                ),
      );
}
