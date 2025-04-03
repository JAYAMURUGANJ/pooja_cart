// To parse this JSON data, do
//
//     final myOrdersResponseModel = myOrdersResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pooja_cart/features/domain/entities/my_orders/my_orders_response.dart';

List<MyOrdersResponseModel> myOrdersResponseModelFromJson(String str) =>
    List<MyOrdersResponseModel>.from(
      json.decode(str).map((x) => MyOrdersResponseModel.fromJson(x)),
    );

String myOrdersResponseModelToJson(List<MyOrdersResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyOrdersResponseModel extends MyOrdersResponse {
  MyOrdersResponseModel({
    required super.orderId,
    required super.orderDate,
    required super.orderStatus,
    required super.name,
    required super.mobileNo,
    required super.email,
    required super.shippingAddress,
    required super.shippingMethod,
    required super.subTotal,
    required super.discount,
    required super.shippingCost,
    required super.tax,
    required super.total,
    required super.paymentMethod,
    required super.transactionId,
    required super.couponCode,
    required super.orderNotes,
    required super.orderReference,
    required super.orderItems,
    required super.statusHistory,
  });

  factory MyOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      MyOrdersResponseModel(
        orderId: json["order_id"],
        orderDate:
            json["order_date"] == null
                ? null
                : DateTime.parse(json["order_date"]),
        orderStatus: json["order_status"],
        name: json["name"],
        mobileNo: json["mobile_no"],
        email: json["email"],
        shippingAddress: json["shipping_address"],
        shippingMethod: json["shipping_method"],
        subTotal: json["sub_total"]?.toDouble(),
        discount: json["discount"]?.toDouble(),
        shippingCost: json["shipping_cost"]?.toDouble(),
        tax: json["tax"]?.toDouble(),
        total: json["total"]?.toDouble(),
        paymentMethod: json["payment_method"],
        transactionId: json["transaction_id"],
        couponCode: json["coupon_code"],
        orderNotes: json["order_notes"],
        orderReference: json["order_reference"],
        orderItems:
            json["order_items"] == null
                ? []
                : List<OrderItem>.from(
                  json["order_items"]!.map((x) => OrderItem.fromJson(x)),
                ),
        statusHistory:
            json["status_history"] == null
                ? []
                : List<StatusHistory>.from(
                  json["status_history"]!.map((x) => StatusHistory.fromJson(x)),
                ),
      );

  @override
  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "order_date": orderDate?.toIso8601String(),
    "order_status": orderStatus,
    "name": name,
    "mobile_no": mobileNo,
    "email": email,
    "shipping_address": shippingAddress,
    "shipping_method": shippingMethod,
    "sub_total": subTotal,
    "discount": discount,
    "shipping_cost": shippingCost,
    "tax": tax,
    "total": total,
    "payment_method": paymentMethod,
    "transaction_id": transactionId,
    "coupon_code": couponCode,
    "order_notes": orderNotes,
    "order_reference": orderReference,
    "order_items":
        orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    "status_history":
        statusHistory == null
            ? []
            : List<dynamic>.from(statusHistory!.map((x) => x.toJson())),
  };
}
