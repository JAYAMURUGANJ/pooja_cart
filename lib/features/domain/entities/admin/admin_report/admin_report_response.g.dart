// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReportResponse _$AdminReportResponseFromJson(Map<String, dynamic> json) =>
    AdminReportResponse(
      filters:
          json['filters'] == null
              ? null
              : Filters.fromJson(json['filters'] as Map<String, dynamic>),
      summary:
          json['summary'] == null
              ? null
              : Summary.fromJson(json['summary'] as Map<String, dynamic>),
      charts:
          json['charts'] == null
              ? null
              : Charts.fromJson(json['charts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminReportResponseToJson(
  AdminReportResponse instance,
) => <String, dynamic>{
  'filters': instance.filters,
  'summary': instance.summary,
  'charts': instance.charts,
};

Charts _$ChartsFromJson(Map<String, dynamic> json) => Charts(
  salesByDate:
      (json['sales_by_date'] as List<dynamic>?)
          ?.map((e) => SalesByDate.fromJson(e as Map<String, dynamic>))
          .toList(),
  orderStatusSummary:
      (json['order_status_summary'] as List<dynamic>?)
          ?.map((e) => OrderStatusSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ChartsToJson(Charts instance) => <String, dynamic>{
  'sales_by_date': instance.salesByDate,
  'order_status_summary': instance.orderStatusSummary,
};

OrderStatusSummary _$OrderStatusSummaryFromJson(Map<String, dynamic> json) =>
    OrderStatusSummary(
      status: json['status'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderStatusSummaryToJson(OrderStatusSummary instance) =>
    <String, dynamic>{'status': instance.status, 'count': instance.count};

SalesByDate _$SalesByDateFromJson(Map<String, dynamic> json) => SalesByDate(
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  totalOrders: (json['total_orders'] as num?)?.toInt(),
  totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SalesByDateToJson(SalesByDate instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'total_orders': instance.totalOrders,
      'total_revenue': instance.totalRevenue,
    };

Filters _$FiltersFromJson(Map<String, dynamic> json) => Filters(
  startDate:
      json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
  endDate:
      json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
  languageCode: json['language_code'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$FiltersToJson(Filters instance) => <String, dynamic>{
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'language_code': instance.languageCode,
  'limit': instance.limit,
  'offset': instance.offset,
};

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
  totalOrders: (json['total_orders'] as num?)?.toInt(),
  totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
  averageOrderValue: (json['average_order_value'] as num?)?.toDouble(),
  totalCustomers: (json['total_customers'] as num?)?.toInt(),
);

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
  'total_orders': instance.totalOrders,
  'total_revenue': instance.totalRevenue,
  'average_order_value': instance.averageOrderValue,
  'total_customers': instance.totalCustomers,
};
