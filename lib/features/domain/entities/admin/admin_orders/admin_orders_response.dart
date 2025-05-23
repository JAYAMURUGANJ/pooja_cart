import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'admin_orders_response.g.dart';

List<AdminOrdersResponse> adminOrdersResponseFromJson(String str) =>
    List<AdminOrdersResponse>.from(
      json.decode(str).map((x) => AdminOrdersResponse.fromJson(x)),
    );

String adminOrdersResponseToJson(List<AdminOrdersResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AdminOrdersResponse {
  @JsonKey(name: "orders")
  List<OrdersList>? orders;

  @JsonKey(name: "pagination")
  Pagination? pagination;

  AdminOrdersResponse({this.orders, this.pagination});

  factory AdminOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminOrdersResponseToJson(this);
}

@JsonSerializable()
class OrdersList {
  @JsonKey(name: "order_id")
  int? orderId;

  @JsonKey(name: "order_date")
  DateTime? orderDate;

  @JsonKey(name: "order_status")
  String? orderStatus;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "mobile_no")
  String? mobileNo;

  @JsonKey(name: "shipping_method")
  String? shippingMethod;

  @JsonKey(name: "sub_total")
  int? subTotal;

  @JsonKey(name: "total")
  double? total;

  @JsonKey(name: "payment_method")
  String? paymentMethod;

  @JsonKey(name: "order_items")
  List<OrderItem>? orderItems;

  OrdersList({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.name,
    this.mobileNo,
    this.shippingMethod,
    this.subTotal,
    this.total,
    this.paymentMethod,
    this.orderItems,
  });

  factory OrdersList.fromJson(Map<String, dynamic> json) =>
      _$OrdersListFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersListToJson(this);
}

@JsonSerializable()
class OrderItem {
  @JsonKey(name: "order_item_id")
  int? orderItemId;

  @JsonKey(name: "product_id")
  int? productId;

  @JsonKey(name: "unit_id")
  int? unitId;

  @JsonKey(name: "quantity")
  int? quantity;

  @JsonKey(name: "selling_price")
  int? sellingPrice;

  @JsonKey(name: "mrp")
  int? mrp;

  @JsonKey(name: "item_sub_total")
  int? itemSubTotal;

  @JsonKey(name: "item_discount")
  int? itemDiscount;

  @JsonKey(name: "conversion_factor")
  int? conversionFactor;

  @JsonKey(name: "product_name")
  String? productName;

  @JsonKey(name: "product_description")
  String? productDescription;

  @JsonKey(name: "unit_name")
  String? unitName;

  @JsonKey(name: "unit_abbreviation")
  String? unitAbbreviation;

  @JsonKey(name: "product_image")
  dynamic productImage;

  OrderItem({
    this.orderItemId,
    this.productId,
    this.unitId,
    this.quantity,
    this.sellingPrice,
    this.mrp,
    this.itemSubTotal,
    this.itemDiscount,
    this.conversionFactor,
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
class Pagination {
  @JsonKey(name: "total")
  int? total;

  @JsonKey(name: "page")
  int? page;

  @JsonKey(name: "limit")
  int? limit;

  @JsonKey(name: "total_pages")
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
