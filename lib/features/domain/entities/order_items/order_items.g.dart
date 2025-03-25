// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) => OrderItems(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  unitId: json['unit_id'] as int?,
);

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit_id': instance.unitId,
    };
