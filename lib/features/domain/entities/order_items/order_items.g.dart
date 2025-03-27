// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) => OrderItems(
  productId: (json['product_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  unitId: json['unit_id'] as int?,
  quantity: json['quantity'] as int?,
  sellingPrice: json['selling_price'] as int?,
  mrp: json['mrp'] as int?,
);

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'unit_id': instance.unitId,
      'quantity': instance.quantity,
      'selling_price': instance.sellingPrice,
      'mrp': instance.mrp,
    };
