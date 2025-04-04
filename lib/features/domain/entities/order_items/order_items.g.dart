// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) => OrderItems(
  productId: (json['product_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  unitId: (json['unit_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  sellingPrice: (json['selling_price'] as num?)?.toInt(),
  mrp: (json['mrp'] as num?)?.toInt(),
  conversionFactor: (json['conversion_factor'] as num?)?.toInt(),
  unitAbbreviation: json['unit_abbreviation'] as String?,
);

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'unit_id': instance.unitId,
      'quantity': instance.quantity,
      'selling_price': instance.sellingPrice,
      'mrp': instance.mrp,
      'conversion_factor': instance.conversionFactor,
      'unit_abbreviation': instance.unitAbbreviation,
    };
