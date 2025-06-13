// To parse this JSON data, do
//
//     final adminReportResponseModel = adminReportResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pooja_cart/features/domain/entities/admin/admin_report/admin_report_response.dart';

AdminReportResponseModel adminReportResponseModelFromJson(String str) =>
    AdminReportResponseModel.fromJson(json.decode(str));

String adminReportResponseModelToJson(AdminReportResponseModel data) =>
    json.encode(data.toJson());

class AdminReportResponseModel extends AdminReportResponse {
  AdminReportResponseModel({
    required super.filters,
    required super.summary,
    required super.charts,
  });

  factory AdminReportResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => AdminReportResponseModel(
    filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    charts: json["charts"] == null ? null : Charts.fromJson(json["charts"]),
  );

  @override
  Map<String, dynamic> toJson() => {
    "filters": filters?.toJson(),
    "summary": summary?.toJson(),
    "charts": charts?.toJson(),
  };
}
