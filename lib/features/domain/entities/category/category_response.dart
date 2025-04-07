// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "units")
  final List<CategoryUnit>? units;

  CategoryResponse({this.id, this.name, this.units});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}

@JsonSerializable()
class CategoryUnit {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "abbreviation")
  final String? abbreviation;

  CategoryUnit({this.id, this.name, this.abbreviation});

  factory CategoryUnit.fromJson(Map<String, dynamic> json) =>
      _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}
