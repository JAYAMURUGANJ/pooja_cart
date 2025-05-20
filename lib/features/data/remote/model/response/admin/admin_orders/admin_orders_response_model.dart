// To parse this JSON data, do
//
//     final adminOrdersResponseModel = adminOrdersResponseModelFromJson(jsonString);

import '../../../../../../domain/entities/admin/admin_orders/admin_orders_response.dart';

class AdminOrdersResponseModel extends AdminOrdersResponse {
  AdminOrdersResponseModel({required super.orders, required super.pagination});

  factory AdminOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminOrdersResponseModel(
        orders:
            json["orders"] == null
                ? []
                : List<OrdersList>.from(
                  json["orders"]!.map((x) => OrdersList.fromJson(x)),
                ),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  @override
  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}
