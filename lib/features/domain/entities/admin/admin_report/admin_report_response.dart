// To parse this JSON data, do
//
//     final adminReportResponse = adminReportResponseFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'admin_report_response.g.dart';

AdminReportResponse adminReportResponseFromJson(String str) =>
    AdminReportResponse.fromJson(json.decode(str));

String adminReportResponseToJson(AdminReportResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AdminReportResponse {
  @JsonKey(name: "filters")
  final Filters? filters;
  @JsonKey(name: "summary")
  final Summary? summary;
  @JsonKey(name: "charts")
  final Charts? charts;

  AdminReportResponse({this.filters, this.summary, this.charts});

  factory AdminReportResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReportResponseToJson(this);
}

@JsonSerializable()
class Charts {
  @JsonKey(name: "sales_by_date")
  final List<SalesByDate>? salesByDate;
  @JsonKey(name: "order_status_summary")
  final List<OrderStatusSummary>? orderStatusSummary;

  Charts({this.salesByDate, this.orderStatusSummary});

  factory Charts.fromJson(Map<String, dynamic> json) => _$ChartsFromJson(json);

  Map<String, dynamic> toJson() => _$ChartsToJson(this);
}

@JsonSerializable()
class OrderStatusSummary {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "count")
  final int? count;

  OrderStatusSummary({this.status, this.count});

  factory OrderStatusSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusSummaryToJson(this);
}

@JsonSerializable()
class SalesByDate {
  @JsonKey(name: "date")
  final DateTime? date;
  @JsonKey(name: "total_orders")
  final int? totalOrders;
  @JsonKey(name: "total_revenue")
  final double? totalRevenue;

  SalesByDate({this.date, this.totalOrders, this.totalRevenue});

  factory SalesByDate.fromJson(Map<String, dynamic> json) =>
      _$SalesByDateFromJson(json);

  Map<String, dynamic> toJson() => _$SalesByDateToJson(this);
}

@JsonSerializable()
class Filters {
  @JsonKey(name: "start_date")
  final DateTime? startDate;
  @JsonKey(name: "end_date")
  final DateTime? endDate;
  @JsonKey(name: "language_code")
  final String? languageCode;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "offset")
  final int? offset;

  Filters({
    this.startDate,
    this.endDate,
    this.languageCode,
    this.limit,
    this.offset,
  });

  factory Filters.fromJson(Map<String, dynamic> json) =>
      _$FiltersFromJson(json);

  Map<String, dynamic> toJson() => _$FiltersToJson(this);
}

@JsonSerializable()
class Summary {
  @JsonKey(name: "total_orders")
  final int? totalOrders;
  @JsonKey(name: "total_revenue")
  final double? totalRevenue;
  @JsonKey(name: "average_order_value")
  final double? averageOrderValue;
  @JsonKey(name: "total_customers")
  final int? totalCustomers;

  Summary({
    this.totalOrders,
    this.totalRevenue,
    this.averageOrderValue,
    this.totalCustomers,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}
