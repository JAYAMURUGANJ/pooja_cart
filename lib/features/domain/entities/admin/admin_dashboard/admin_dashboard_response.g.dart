// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminDashboardResponse _$AdminDashboardResponseFromJson(
  Map<String, dynamic> json,
) => AdminDashboardResponse(
  timestamp: json['timestamp'] as String?,
  adminUser:
      json['admin_user'] == null
          ? null
          : AdminUser.fromJson(json['admin_user'] as Map<String, dynamic>),
  store:
      json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
  metrics:
      json['metrics'] == null
          ? null
          : Metrics.fromJson(json['metrics'] as Map<String, dynamic>),
  products:
      json['products'] == null
          ? null
          : Products.fromJson(json['products'] as Map<String, dynamic>),
  recentOrders:
      (json['recent_orders'] as List<dynamic>?)
          ?.map((e) => RecentOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AdminDashboardResponseToJson(
  AdminDashboardResponse instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'admin_user': instance.adminUser,
  'store': instance.store,
  'metrics': instance.metrics,
  'products': instance.products,
  'recent_orders': instance.recentOrders,
};

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
  adminId: json['admin_id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  lastLogin: json['last_login'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
);

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
  'admin_id': instance.adminId,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'last_login': instance.lastLogin,
  'profile_picture_url': instance.profilePictureUrl,
};

Metrics _$MetricsFromJson(Map<String, dynamic> json) => Metrics(
  todayOrders: (json['today_orders'] as num?)?.toInt(),
  todayRevenue: json['today_revenue'],
  totalOrders: (json['total_orders'] as num?)?.toInt(),
  totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MetricsToJson(Metrics instance) => <String, dynamic>{
  'today_orders': instance.todayOrders,
  'today_revenue': instance.todayRevenue,
  'total_orders': instance.totalOrders,
  'total_revenue': instance.totalRevenue,
};

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
  totalProducts: (json['total_products'] as num?)?.toInt(),
  activeProducts: (json['active_products'] as num?)?.toInt(),
  inactiveProducts: (json['inactive_products'] as num?)?.toInt(),
  outOfStock: (json['out_of_stock'] as num?)?.toInt(),
  lowStock:
      (json['low_stock'] as List<dynamic>?)
          ?.map((e) => LowStock.fromJson(e as Map<String, dynamic>))
          .toList(),
  topSelling:
      (json['top_selling'] as List<dynamic>?)
          ?.map((e) => TopSelling.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
  'total_products': instance.totalProducts,
  'active_products': instance.activeProducts,
  'inactive_products': instance.inactiveProducts,
  'out_of_stock': instance.outOfStock,
  'low_stock': instance.lowStock,
  'top_selling': instance.topSelling,
};

LowStock _$LowStockFromJson(Map<String, dynamic> json) => LowStock(
  productId: (json['product_id'] as num?)?.toInt(),
  productName: json['product_name'] as String?,
  inStock: (json['in_stock'] as num?)?.toInt(),
);

Map<String, dynamic> _$LowStockToJson(LowStock instance) => <String, dynamic>{
  'product_id': instance.productId,
  'product_name': instance.productName,
  'in_stock': instance.inStock,
};

TopSelling _$TopSellingFromJson(Map<String, dynamic> json) => TopSelling(
  productId: (json['product_id'] as num?)?.toInt(),
  productName: json['product_name'] as String?,
  totalSold: (json['total_sold'] as num?)?.toInt(),
);

Map<String, dynamic> _$TopSellingToJson(TopSelling instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'total_sold': instance.totalSold,
    };

RecentOrder _$RecentOrderFromJson(Map<String, dynamic> json) => RecentOrder(
  orderId: (json['order_id'] as num?)?.toInt(),
  customerName: json['customer_name'] as String?,
  mobileNo: json['mobile_no'] as String?,
  email: json['email'],
  orderTotal: (json['order_total'] as num?)?.toInt(),
  orderStatus: json['order_status'] as String?,
  paymentMethod: json['payment_method'] as String?,
  orderDate:
      json['order_date'] == null
          ? null
          : DateTime.parse(json['order_date'] as String),
);

Map<String, dynamic> _$RecentOrderToJson(RecentOrder instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'customer_name': instance.customerName,
      'mobile_no': instance.mobileNo,
      'email': instance.email,
      'order_total': instance.orderTotal,
      'order_status': instance.orderStatus,
      'payment_method': instance.paymentMethod,
      'order_date': instance.orderDate?.toIso8601String(),
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
  storeId: json['store_id'] as String?,
  storeName: json['store_name'] as String?,
);

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'store_id': instance.storeId,
  'store_name': instance.storeName,
};
