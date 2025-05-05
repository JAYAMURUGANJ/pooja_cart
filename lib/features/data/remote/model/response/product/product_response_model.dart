// To parse this JSON data, do
//
//     final productResponseModel = productResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

ProductResponseModel productResponseModelFromJson(String str) =>
    ProductResponseModel.fromJson(json.decode(str));

String productResponseModelToJson(ProductResponseModel data) =>
    json.encode(data.toJson());

class ProductResponseModel extends ProductResponse {
  ProductResponseModel({
    required super.id,
    required super.isActive,
    required super.categoryId,
    required super.name,
    required super.units,
    required super.images,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
        id: json["id"],
        isActive: json["is_active"],
        categoryId: json["category_id"],
        name: json["name"],
        units:
            json["units"] == null
                ? []
                : List<ProductUnit>.from(
                  json["units"]!.map((x) => ProductUnit.fromJson(x)),
                ),
        images:
            json["images"] == null
                ? []
                : List<Image>.from(
                  json["images"]!.map((x) => Image.fromJson(x)),
                ),
      );
}
