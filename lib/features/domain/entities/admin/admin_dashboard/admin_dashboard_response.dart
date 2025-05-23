// To parse this JSON data, do
//
//     final adminDashboardResponse = adminDashboardResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'admin_dashboard_response.g.dart';

List<AdminDashboardResponse> adminDashboardResponseFromJson(String str) =>
    List<AdminDashboardResponse>.from(
      json.decode(str).map((x) => AdminDashboardResponse.fromJson(x)),
    );

String adminDashboardResponseToJson(List<AdminDashboardResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class AdminDashboardResponse {
  @JsonKey(name: "timestamp")
  String? timestamp;
  @JsonKey(name: "admin_user")
  AdminUser? adminUser;
  @JsonKey(name: "store")
  Store? store;
  @JsonKey(name: "metrics")
  Metrics? metrics;
  @JsonKey(name: "products")
  Products? products;
  @JsonKey(name: "recent_orders")
  List<RecentOrder>? recentOrders;

  AdminDashboardResponse({
    this.timestamp,
    this.adminUser,
    this.store,
    this.metrics,
    this.products,
    this.recentOrders,
  });

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDashboardResponseToJson(this);
}

@JsonSerializable()
class AdminUser {
  @JsonKey(name: "admin_id")
  String? adminId;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "last_login")
  String? lastLogin;
  @JsonKey(name: "profile_picture_url")
  String? profilePictureUrl;

  AdminUser({
    this.adminId,
    this.name,
    this.email,
    this.role,
    this.lastLogin,
    this.profilePictureUrl,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);
}

@JsonSerializable()
class Metrics {
  @JsonKey(name: "today_orders")
  int? todayOrders;
  @JsonKey(name: "today_revenue")
  dynamic todayRevenue;
  @JsonKey(name: "total_orders")
  int? totalOrders;
  @JsonKey(name: "total_revenue")
  double? totalRevenue;

  Metrics({
    this.todayOrders,
    this.todayRevenue,
    this.totalOrders,
    this.totalRevenue,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) =>
      _$MetricsFromJson(json);

  Map<String, dynamic> toJson() => _$MetricsToJson(this);
}

@JsonSerializable()
class Products {
  @JsonKey(name: "total_products")
  int? totalProducts;
  @JsonKey(name: "active_products")
  int? activeProducts;
  @JsonKey(name: "inactive_products")
  int? inactiveProducts;
  @JsonKey(name: "out_of_stock")
  int? outOfStock;
  @JsonKey(name: "low_stock")
  List<LowStock>? lowStock;
  @JsonKey(name: "top_selling")
  List<TopSelling>? topSelling;

  Products({
    this.totalProducts,
    this.activeProducts,
    this.inactiveProducts,
    this.outOfStock,
    this.lowStock,
    this.topSelling,
  });

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);
}

@JsonSerializable()
class LowStock {
  @JsonKey(name: "product_id")
  int? productId;
  @JsonKey(name: "product_name")
  String? productName;
  @JsonKey(name: "in_stock")
  int? inStock;

  LowStock({this.productId, this.productName, this.inStock});

  factory LowStock.fromJson(Map<String, dynamic> json) =>
      _$LowStockFromJson(json);

  Map<String, dynamic> toJson() => _$LowStockToJson(this);
}

@JsonSerializable()
class TopSelling {
  @JsonKey(name: "product_id")
  int? productId;
  @JsonKey(name: "product_name")
  String? productName;
  @JsonKey(name: "total_sold")
  int? totalSold;

  TopSelling({this.productId, this.productName, this.totalSold});

  factory TopSelling.fromJson(Map<String, dynamic> json) =>
      _$TopSellingFromJson(json);

  Map<String, dynamic> toJson() => _$TopSellingToJson(this);
}

@JsonSerializable()
class RecentOrder {
  @JsonKey(name: "order_id")
  int? orderId;
  @JsonKey(name: "customer_name")
  String? customerName;
  @JsonKey(name: "mobile_no")
  String? mobileNo;
  @JsonKey(name: "email")
  dynamic email;
  @JsonKey(name: "order_total")
  int? orderTotal;
  @JsonKey(name: "order_status")
  String? orderStatus;
  @JsonKey(name: "payment_method")
  String? paymentMethod;
  @JsonKey(name: "order_date")
  DateTime? orderDate;

  RecentOrder({
    this.orderId,
    this.customerName,
    this.mobileNo,
    this.email,
    this.orderTotal,
    this.orderStatus,
    this.paymentMethod,
    this.orderDate,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) =>
      _$RecentOrderFromJson(json);

  Map<String, dynamic> toJson() => _$RecentOrderToJson(this);
}

@JsonSerializable()
class Store {
  @JsonKey(name: "store_id")
  String? storeId;
  @JsonKey(name: "store_name")
  String? storeName;

  Store({this.storeId, this.storeName});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
