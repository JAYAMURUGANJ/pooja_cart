// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitResponse _$UnitResponseFromJson(Map<String, dynamic> json) => UnitResponse(
  id: (json['id'] as num?)?.toInt(),
  languageCode: json['language_code'] as String?,
  name: json['name'] as String?,
  abbreviation: json['abbreviation'] as String?,
);

Map<String, dynamic> _$UnitResponseToJson(UnitResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language_code': instance.languageCode,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
    };
