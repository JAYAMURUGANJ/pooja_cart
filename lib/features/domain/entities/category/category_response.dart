// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'category_response.g.dart';

CategoryResponse categoryResponseFromJson(String str) => CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) => json.encode(data.toJson());

@JsonSerializable()
class CategoryResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "units")
    final List<Unit>? units;

    CategoryResponse({
        this.id,
        this.name,
        this.units,
    });

    factory CategoryResponse.fromJson(Map<String, dynamic> json) => _$CategoryResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}

@JsonSerializable()
class Unit {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "abbreviation")
    final String? abbreviation;

    Unit({
        this.id,
        this.name,
        this.abbreviation,
    });

    factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

    Map<String, dynamic> toJson() => _$UnitToJson(this);
}
