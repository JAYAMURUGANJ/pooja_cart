// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminOrdersResponse _$AdminOrdersResponseFromJson(Map<String, dynamic> json) =>
    AdminOrdersResponse(
      orders:
          (json['orders'] as List<dynamic>)
              .map((e) => OrdersList.fromJson(e as Map<String, dynamic>))
              .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AdminOrdersResponseToJson(
  AdminOrdersResponse instance,
) => <String, dynamic>{
  'orders': instance.orders,
  'pagination': instance.pagination,
};

OrdersList _$OrderFromJson(Map<String, dynamic> json) => OrdersList(
  orderId: (json['order_id'] as num).toInt(),
  orderDate: DateTime.parse(json['order_date'] as String),
  orderStatus: json['order_status'] as String,
  name: json['name'] as String,
  mobileNo: json['mobile_no'] as String,
  shippingMethod: json['shipping_method'] as String,
  subTotal: (json['sub_total'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  paymentMethod: json['payment_method'] as String,
  orderItems:
      (json['order_items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OrderToJson(OrdersList instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'order_date': instance.orderDate.toIso8601String(),
  'order_status': instance.orderStatus,
  'name': instance.name,
  'mobile_no': instance.mobileNo,
  'shipping_method': instance.shippingMethod,
  'sub_total': instance.subTotal,
  'total': instance.total,
  'payment_method': instance.paymentMethod,
  'order_items': instance.orderItems,
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  orderItemId: (json['order_item_id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  unitId: (json['unit_id'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  sellingPrice: (json['selling_price'] as num).toInt(),
  mrp: (json['mrp'] as num).toInt(),
  itemSubTotal: (json['item_sub_total'] as num).toInt(),
  itemDiscount: (json['item_discount'] as num).toInt(),
  conversionFactor: (json['conversion_factor'] as num).toInt(),
  productName: json['product_name'] as String,
  productDescription: json['product_description'] as String,
  unitName: json['unit_name'] as String,
  unitAbbreviation: json['unit_abbreviation'] as String,
  productImage: json['product_image'],
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'order_item_id': instance.orderItemId,
  'product_id': instance.productId,
  'unit_id': instance.unitId,
  'quantity': instance.quantity,
  'selling_price': instance.sellingPrice,
  'mrp': instance.mrp,
  'item_sub_total': instance.itemSubTotal,
  'item_discount': instance.itemDiscount,
  'conversion_factor': instance.conversionFactor,
  'product_name': instance.productName,
  'product_description': instance.productDescription,
  'unit_name': instance.unitName,
  'unit_abbreviation': instance.unitAbbreviation,
  'product_image': instance.productImage,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'total_pages': instance.totalPages,
    };
