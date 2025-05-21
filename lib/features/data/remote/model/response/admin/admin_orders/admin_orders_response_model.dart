import 'dart:convert';

import '../../../../../../domain/entities/admin/admin_orders/admin_orders_response.dart'
    show AdminOrdersResponse, OrdersList, Pagination;

List<AdminOrdersResponseModel> adminOrdersResponseModelFromJson(String str) =>
    List<AdminOrdersResponseModel>.from(
      json.decode(str).map((x) => AdminOrdersResponseModel.fromJson(x)),
    );

String adminOrdersResponseModelToJson(List<AdminOrdersResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminOrdersResponseModel extends AdminOrdersResponse {
  @override
  List<OrdersList>? orders;
  @override
  Pagination? pagination;

  AdminOrdersResponseModel({this.orders, this.pagination});

  factory AdminOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminOrdersResponseModel(
        orders:
            json["orders"] == null
                ? []
                : List<OrdersList>.from(
                  json["orders"]!.map((x) => OrdersList.fromJson(x)),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
      );

  @override
  Map<String, dynamic> toJson() => {
    "orders":
        orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}
