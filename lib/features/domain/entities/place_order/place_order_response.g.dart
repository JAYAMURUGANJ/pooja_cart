// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceOrderResponse _$PlaceOrderResponseFromJson(Map<String, dynamic> json) =>
    PlaceOrderResponse(
      orderId: (json['order_id'] as num?)?.toInt(),
      orderReference: json['order_reference'] as String?,
      orderDate:
          json['order_date'] == null
              ? null
              : DateTime.parse(json['order_date'] as String),
      orderStatus: json['order_status'] as String?,
      shippingDetails:
          json['shipping_details'] == null
              ? null
              : ShippingDetails.fromJson(
                json['shipping_details'] as Map<String, dynamic>,
              ),
      orderItems:
          (json['order_items'] as List<dynamic>?)
              ?.map((e) => PlacedOrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      shippingCost: (json['shipping_cost'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      paymentDetails:
          json['payment_details'] == null
              ? null
              : PaymentDetails.fromJson(
                json['payment_details'] as Map<String, dynamic>,
              ),
      couponCode: json['coupon_code'] as String?,
      orderNotes: json['order_notes'] as String?,
      statusHistory:
          (json['status_history'] as List<dynamic>?)
              ?.map((e) => StatusHistory.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PlaceOrderResponseToJson(PlaceOrderResponse instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_reference': instance.orderReference,
      'order_date': instance.orderDate?.toIso8601String(),
      'order_status': instance.orderStatus,
      'shipping_details': instance.shippingDetails,
      'order_items': instance.orderItems,
      'sub_total': instance.subTotal,
      'discount': instance.discount,
      'shipping_cost': instance.shippingCost,
      'tax': instance.tax,
      'total': instance.total,
      'payment_details': instance.paymentDetails,
      'coupon_code': instance.couponCode,
      'order_notes': instance.orderNotes,
      'status_history': instance.statusHistory,
    };

PlacedOrderItem _$PlacedOrderItemFromJson(Map<String, dynamic> json) =>
    PlacedOrderItem(
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

Map<String, dynamic> _$PlacedOrderItemToJson(PlacedOrderItem instance) =>
    <String, dynamic>{
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

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      paymentMethod: json['payment_method'] as String?,
      transactionId: json['transaction_id'] as String?,
    );

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'payment_method': instance.paymentMethod,
      'transaction_id': instance.transactionId,
    };

ShippingDetails _$ShippingDetailsFromJson(Map<String, dynamic> json) =>
    ShippingDetails(
      name: json['name'] as String?,
      mobileNo: json['mobile_no'] as String?,
      email: json['email'],
      shippingAddress: json['shipping_address'] as String?,
      shippingMethod: json['shipping_method'] as String?,
    );

Map<String, dynamic> _$ShippingDetailsToJson(ShippingDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mobile_no': instance.mobileNo,
      'email': instance.email,
      'shipping_address': instance.shippingAddress,
      'shipping_method': instance.shippingMethod,
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
