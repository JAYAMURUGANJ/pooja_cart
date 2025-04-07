// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'product_response.g.dart';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "is_active")
  final int? isActive;
  @JsonKey(name: "category_id")
  final int? categoryId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "units")
  final List<Unit>? units;
  @JsonKey(name: "images")
  final List<Image>? images;

  ProductResponse({
    this.id,
    this.isActive,
    this.categoryId,
    this.name,
    this.units,
    this.images,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable()
class Image {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "is_primary")
  final int? isPrimary;
  @JsonKey(name: "display_order")
  final int? displayOrder;

  Image({this.id, this.imageUrl, this.isPrimary, this.displayOrder});

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

@JsonSerializable()
class Unit {
  @JsonKey(name: "unit_id")
  final int? unitId;
  @JsonKey(name: "conversion_factor")
  final int? conversionFactor;
  @JsonKey(name: "mrp")
  final int? mrp;
  @JsonKey(name: "selling_price")
  final int? sellingPrice;
  @JsonKey(name: "is_default")
  final int? isDefault;
  @JsonKey(name: "in_stock")
  final int? inStock;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "abbreviation")
  final String? abbreviation;

  Unit({
    this.unitId,
    this.conversionFactor,
    this.mrp,
    this.sellingPrice,
    this.isDefault,
    this.inStock,
    this.name,
    this.abbreviation,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}
