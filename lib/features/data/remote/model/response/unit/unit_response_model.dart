// To parse this JSON data, do
//
//     final unitResponseModel = unitResponseModelFromJson(jsonString);

import 'dart:convert';

import '../../../../../domain/entities/unit/unit_response.dart';

UnitResponseModel unitResponseModelFromJson(String str) =>
    UnitResponseModel.fromJson(json.decode(str));

String unitResponseModelToJson(UnitResponseModel data) =>
    json.encode(data.toJson());

class UnitResponseModel extends UnitResponse {
  UnitResponseModel({
    required super.id,
    required super.languageCode,
    required super.name,
    required super.abbreviation,
  });

  factory UnitResponseModel.fromJson(Map<String, dynamic> json) =>
      UnitResponseModel(
        id: json["id"],
        languageCode: json["language_code"],
        name: json["name"],
        abbreviation: json["abbreviation"],
      );
}
