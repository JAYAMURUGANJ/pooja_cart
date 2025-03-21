// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      id: (json['id'] as num?)?.toInt(),
      isActive: (json['is_active'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      units:
          (json['units'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e as Map<String, dynamic>))
              .toList(),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
              .toList(),
      mrp: (json['mrp'] as num?)?.toInt(),
      sellingPrice: (json['selling_price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_active': instance.isActive,
      'category_id': instance.categoryId,
      'name': instance.name,
      'units': instance.units,
      'images': instance.images,
      'mrp': instance.mrp,
      'selling_price': instance.sellingPrice,
    };

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
  id: (json['id'] as num?)?.toInt(),
  imageUrl: json['image_url'] as String?,
  isPrimary: (json['is_primary'] as num?)?.toInt(),
  displayOrder: (json['display_order'] as num?)?.toInt(),
);

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
  'id': instance.id,
  'image_url': instance.imageUrl,
  'is_primary': instance.isPrimary,
  'display_order': instance.displayOrder,
};

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
  unitId: (json['unit_id'] as num?)?.toInt(),
  conversionFactor: (json['conversion_factor'] as num?)?.toInt(),
  mrp: (json['mrp'] as num?)?.toInt(),
  sellingPrice: (json['selling_price'] as num?)?.toInt(),
  isDefault: (json['is_default'] as num?)?.toInt(),
  inStock: (json['in_stock'] as num?)?.toInt(),
  name: json['name'] as String?,
  abbreviation: json['abbreviation'] as String?,
);

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
  'unit_id': instance.unitId,
  'conversion_factor': instance.conversionFactor,
  'mrp': instance.mrp,
  'selling_price': instance.sellingPrice,
  'is_default': instance.isDefault,
  'in_stock': instance.inStock,
  'name': instance.name,
  'abbreviation': instance.abbreviation,
};
