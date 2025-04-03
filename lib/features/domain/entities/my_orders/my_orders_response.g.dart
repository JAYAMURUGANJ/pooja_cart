// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrdersResponse _$MyOrdersResponseFromJson(Map<String, dynamic> json) =>
    MyOrdersResponse(
      orderId: (json['order_id'] as num?)?.toInt(),
      orderDate:
          json['order_date'] == null
              ? null
              : DateTime.parse(json['order_date'] as String),
      orderStatus: json['order_status'] as String?,
      name: json['name'] as String?,
      mobileNo: json['mobile_no'] as String?,
      email: json['email'],
      shippingAddress: json['shipping_address'] as String?,
      shippingMethod: json['shipping_method'] as String?,
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      shippingCost: (json['shipping_cost'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'] as String?,
      transactionId: json['transaction_id'] as String?,
      couponCode: json['coupon_code'] as String?,
      orderNotes: json['order_notes'] as String?,
      orderReference: json['order_reference'] as String?,
      orderItems:
          (json['order_items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      statusHistory:
          (json['status_history'] as List<dynamic>?)
              ?.map((e) => StatusHistory.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$MyOrdersResponseToJson(MyOrdersResponse instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_date': instance.orderDate?.toIso8601String(),
      'order_status': instance.orderStatus,
      'name': instance.name,
      'mobile_no': instance.mobileNo,
      'email': instance.email,
      'shipping_address': instance.shippingAddress,
      'shipping_method': instance.shippingMethod,
      'sub_total': instance.subTotal,
      'discount': instance.discount,
      'shipping_cost': instance.shippingCost,
      'tax': instance.tax,
      'total': instance.total,
      'payment_method': instance.paymentMethod,
      'transaction_id': instance.transactionId,
      'coupon_code': instance.couponCode,
      'order_notes': instance.orderNotes,
      'order_reference': instance.orderReference,
      'order_items': instance.orderItems,
      'status_history': instance.statusHistory,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  orderItemId: (json['order_item_id'] as num?)?.toInt(),
  productId: (json['product_id'] as num?)?.toInt(),
  unitId: (json['unit_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  sellingPrice: (json['selling_price'] as num?)?.toDouble(),
  mrp: (json['mrp'] as num?)?.toInt(),
  itemSubTotal: (json['item_sub_total'] as num?)?.toDouble(),
  itemDiscount: (json['item_discount'] as num?)?.toDouble(),
  productName: json['product_name'] as String?,
  productDescription: json['product_description'] as String?,
  unitName: json['unit_name'] as String?,
  unitAbbreviation: json['unit_abbreviation'] as String?,
  productImage: json['product_image'] as String?,
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
  'product_name': instance.productName,
  'product_description': instance.productDescription,
  'unit_name': instance.unitName,
  'unit_abbreviation': instance.unitAbbreviation,
  'product_image': instance.productImage,
};

StatusHistory _$StatusHistoryFromJson(Map<String, dynamic> json) =>
    StatusHistory(
      status: json['status'] as String?,
      statusDescription: json['status_description'] as String?,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$StatusHistoryToJson(StatusHistory instance) =>
    <String, dynamic>{
      'status': instance.status,
      'status_description': instance.statusDescription,
      'created_at': instance.createdAt?.toIso8601String(),
    };
