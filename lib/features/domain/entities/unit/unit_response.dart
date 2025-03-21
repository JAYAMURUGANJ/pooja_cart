// To parse this JSON data, do
//
//     final unitResponse = unitResponseFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'unit_response.g.dart';

UnitResponse unitResponseFromJson(String str) => UnitResponse.fromJson(json.decode(str));

String unitResponseToJson(UnitResponse data) => json.encode(data.toJson());

@JsonSerializable()
class UnitResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "language_code")
    final String? languageCode;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "abbreviation")
    final String? abbreviation;

    UnitResponse({
        this.id,
        this.languageCode,
        this.name,
        this.abbreviation,
    });

    factory UnitResponse.fromJson(Map<String, dynamic> json) => _$UnitResponseFromJson(json);

    Map<String, dynamic> toJson() => _$UnitResponseToJson(this);
}
