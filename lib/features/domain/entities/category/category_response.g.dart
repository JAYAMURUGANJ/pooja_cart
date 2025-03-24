// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      units:
          (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'units': instance.units,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  abbreviation: json['abbreviation'] as String?,
);

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'abbreviation': instance.abbreviation,
};
