// To parse this JSON data, do
//
//     final adminDashboardResponseModel = adminDashboardResponseModelFromJson(jsonString);

import 'dart:convert';

import '../../../../../../domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

List<AdminDashboardResponseModel> adminDashboardResponseModelFromJson(
  String str,
) => List<AdminDashboardResponseModel>.from(
  json.decode(str).map((x) => AdminDashboardResponseModel.fromJson(x)),
);

String adminDashboardResponseModelToJson(
  List<AdminDashboardResponseModel> data,
) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminDashboardResponseModel extends AdminDashboardResponse {
  AdminDashboardResponseModel({
    required super.timestamp,
    required super.adminUser,
    required super.store,
    required super.metrics,
    required super.products,
    required super.recentOrders,
  });

  factory AdminDashboardResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => AdminDashboardResponseModel(
    timestamp: json["timestamp"],
    adminUser:
        json["admin_user"] == null
            ? null
            : AdminUser.fromJson(json["admin_user"]),
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    metrics: json["metrics"] == null ? null : Metrics.fromJson(json["metrics"]),
    products:
        json["products"] == null ? null : Products.fromJson(json["products"]),
    recentOrders:
        json["recent_orders"] == null
            ? []
            : List<RecentOrder>.from(
              json["recent_orders"]!.map((x) => RecentOrder.fromJson(x)),
            ),
  );

  @override
  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "admin_user": adminUser?.toJson(),
    "store": store?.toJson(),
    "metrics": metrics?.toJson(),
    "products": products?.toJson(),
    "recent_orders":
        recentOrders == null
            ? []
            : List<dynamic>.from(recentOrders!.map((x) => x.toJson())),
  };
}
