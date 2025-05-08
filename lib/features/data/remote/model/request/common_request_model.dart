// To parse this JSON data, do
//
//     final commonRequestModel = commonRequestModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io' show File;

import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:flutter/foundation.dart';

import 'place_order_request.dart';

CommonRequestModel commonRequestModelFromJson(String str) =>
    CommonRequestModel.fromJson(json.decode(str));

String commonRequestModelToJson(CommonRequestModel data) =>
    json.encode(data.toJson());

class CommonRequestModel {
  final int? categoryId;
  final bool? isActive;
  final List<Translation>? translations;
  final List<ProductUnit>? units;
  final List<ProductImage>? images;
  final PlaceOrderRequest? placeOrderRequest;
  final String? orderId;
  final String? mobileNo;

  CommonRequestModel({
    this.categoryId,
    this.isActive,
    this.translations,
    this.units,
    this.images,
    this.placeOrderRequest,
    this.orderId,
    this.mobileNo,
  });

  CommonRequestModel copyWith({
    int? categoryId,
    bool? isActive,
    List<Translation>? translations,
    List<ProductUnit>? units,
    List<ProductImage>? images,
    PlaceOrderRequest? placeOrderRequest,
    String? orderId,
    String? mobileNo,
  }) => CommonRequestModel(
    categoryId: categoryId ?? this.categoryId,
    isActive: isActive ?? this.isActive,
    translations: translations ?? this.translations,
    units: units ?? this.units,
    images: images ?? this.images,
    placeOrderRequest: placeOrderRequest ?? this.placeOrderRequest,
    orderId: orderId ?? this.orderId,
    mobileNo: mobileNo ?? this.mobileNo,
  );

  factory CommonRequestModel.fromJson(Map<String, dynamic> json) =>
      CommonRequestModel(
        categoryId: json["category_id"],
        isActive: json["is_active"],
        translations:
            json["translations"] == null
                ? []
                : List<Translation>.from(
                  json["translations"]!.map((x) => Translation.fromJson(x)),
                ),
        units:
            json["units"] == null
                ? []
                : List<ProductUnit>.from(
                  json["units"]!.map((x) => ProductUnit.fromJson(x)),
                ),
        images:
            json["images"] == null
                ? []
                : List<ProductImage>.from(
                  json["images"]!.map((x) => ProductImage.fromJson(x)),
                ),
        placeOrderRequest:
            json["place_order_request"] == null
                ? null
                : PlaceOrderRequest.fromJson(json["place_order_request"]),
        orderId: json["order_id"],
        mobileNo: json["mobile_no"],
      );

  Map<String, dynamic> toJson() => {
    if (categoryId != null) "category_id": categoryId,
    if (isActive != null) "is_active": isActive,
    if (translations != null)
      "translations":
          translations == null
              ? []
              : List<dynamic>.from(translations!.map((x) => x.toJson())),
    if (units != null)
      "units":
          units == null
              ? []
              : List<dynamic>.from(units!.map((x) => x.toJson())),
    if (images != null)
      "images":
          images == null
              ? []
              : List<dynamic>.from(images!.map((x) => x.toJson())),
    if (placeOrderRequest != null)
      "place_order_request": placeOrderRequest!.toJson(),
    if (orderId != null) "order_id": orderId,
    if (mobileNo != null) "mobile_no": mobileNo,
  };
}

class ProductImage {
  final String? imageUrl;
  final bool? isPrimary;
  final int? displayOrder;
  final String? filePath;
  final Uint8List? bytes;
  final String? fileName;
  final String? base64String;

  ProductImage({
    this.imageUrl,
    this.isPrimary,
    this.displayOrder,
    this.filePath,
    this.bytes,
    this.fileName,
    this.base64String,
  });

  ProductImage copyWith({
    String? imageUrl,
    bool? isPrimary,
    int? displayOrder,
    String? filePath,
    Uint8List? bytes,
    String? fileName,
    String? base64String,
  }) => ProductImage(
    imageUrl: imageUrl ?? this.imageUrl,
    isPrimary: isPrimary ?? this.isPrimary,
    displayOrder: displayOrder ?? this.displayOrder,
    filePath: filePath ?? this.filePath,
    bytes: bytes ?? this.bytes,
    fileName: fileName ?? this.fileName,
    base64String: base64String ?? this.base64String,
  );

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    imageUrl: json["image_url"],
    isPrimary: json["is_primary"],
    displayOrder: json["display_order"],
    filePath: json["file_path"],
    bytes: json["bytes"] != null ? Uint8List.fromList(json["bytes"]) : null,
    fileName: json["file_name"],
    base64String: json["base64_string"],
  );

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "is_primary": isPrimary,
    "display_order": displayOrder,
    "file_path": filePath,
    "bytes": bytes,
    "file_name": fileName,
    "base64_string": base64String,
  };
}

class Translation {
  final String? lang;
  final String? name;
  final String? description;

  Translation({this.lang, this.name, this.description});

  Translation copyWith({String? lang, String? name, String? description}) =>
      Translation(
        lang: lang ?? this.lang,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
    lang: json["lang"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "lang": lang,
    "name": name,
    "description": description,
  };
}

class ProductUnit {
  final int? unitId;
  final String? name;
  final String? abbreviation;
  final int? conversionFactor;
  final double? mrp;
  final double? sellingPrice;
  final int? inStock;
  final int? isDefault;

  ProductUnit({
    this.unitId,
    this.name,
    this.abbreviation,
    this.conversionFactor,
    this.mrp,
    this.sellingPrice,
    this.inStock,
    this.isDefault,
  });

  ProductUnit copyWith({
    int? unitId,
    String? name,
    String? abbreviation,
    int? conversionFactor,
    double? mrp,
    double? sellingPrice,
    int? inStock,
    int? isDefault,
  }) => ProductUnit(
    unitId: unitId ?? this.unitId,
    name: name ?? this.name,
    abbreviation: abbreviation ?? this.abbreviation,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    mrp: mrp ?? this.mrp,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    inStock: inStock ?? this.inStock,
    isDefault: isDefault ?? this.isDefault,
  );

  factory ProductUnit.fromJson(Map<String, dynamic> json) => ProductUnit(
    unitId: json["unit_id"],
    name: json["name"],
    abbreviation: json["abbreviation"],
    conversionFactor: json["conversion_factor"],
    mrp: json["mrp"],
    sellingPrice: json["selling_price"],
    inStock: json["in_stock"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "unit_id": unitId,
    "name": name,
    "abbreviation": abbreviation,
    "conversion_factor": conversionFactor,
    "mrp": mrp,
    "selling_price": sellingPrice,
    "in_stock": inStock,
    "is_default": isDefault,
  };
}

extension FormDataBuilder on CommonRequestModel {
  Future<FormData> toFormData() async {
    try {
      final files = await Future.wait(
        images
                ?.where(
                  (img) => kIsWeb ? img.bytes != null : img.filePath != null,
                )
                .map((img) async {
                  if (kIsWeb) {
                    return MultipartFile.fromBytes(
                      img.bytes!,
                      filename:
                          img.fileName ??
                          'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
                    );
                  } else {
                    final file = File(img.filePath!);
                    return await MultipartFile.fromFile(
                      img.filePath!,
                      filename: img.fileName ?? file.path.split('/').last,
                    );
                  }
                })
                .toList() ??
            [],
      );

      final imageMetadata =
          images
              ?.where((img) => img.imageUrl != null)
              .map(
                (img) => {
                  "image_url": img.imageUrl!,
                  "is_primary": img.isPrimary ?? false,
                  "display_order": img.displayOrder ?? 0,
                },
              )
              .toList() ??
          [];

      return FormData.fromMap({
        if (categoryId != null) 'category_id': categoryId,
        if (isActive != null) 'is_active': isActive,
        if (orderId != null) 'order_id': orderId,
        if (mobileNo != null) 'mobile_no': mobileNo,
        if (translations != null)
          'translations': jsonEncode(
            translations!.map((e) => e.toJson()).toList(),
          ),
        if (units != null)
          'units': jsonEncode(units!.map((e) => e.toJson()).toList()),
        if (placeOrderRequest != null)
          'place_order_request': jsonEncode(placeOrderRequest!.toJson()),
        if (imageMetadata.isNotEmpty) 'images': jsonEncode(imageMetadata),
        if (files.isNotEmpty) 'files': files,
      });
    } catch (e) {
      throw Exception('Failed to create FormData: $e');
    }
  }
}
