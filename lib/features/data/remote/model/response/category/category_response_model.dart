// To parse this JSON data, do
//
//     final categoryResponseModel = categoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pooja_cart/features/domain/entities/category/category_response.dart';

CategoryResponseModel categoryResponseModelFromJson(String str) =>
    CategoryResponseModel.fromJson(json.decode(str));

String categoryResponseModelToJson(CategoryResponseModel data) =>
    json.encode(data.toJson());

class CategoryResponseModel extends CategoryResponse {
  CategoryResponseModel({
    required super.id,
    required super.name,
    required super.units,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoryResponseModel(
        id: json["id"],
        name: json["name"],
        units:
            json["units"] == null
                ? []
                : List<Unit>.from(json["units"]!.map((x) => Unit.fromJson(x))),
      );
}
