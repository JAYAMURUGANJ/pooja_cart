// To parse this JSON data, do
//
//     final commonRequestModel = commonRequestModelFromJson(jsonString);

import 'dart:convert';

CommonRequestModel commonRequestModelFromJson(String str) =>
    CommonRequestModel.fromJson(json.decode(str));

String commonRequestModelToJson(CommonRequestModel data) =>
    json.encode(data.toJson());

class CommonRequestModel {
  final int? categoryId;
  final bool? isActive;
  final List<Translation>? translations;
  final List<Unit>? units;
  final List<Image>? images;

  CommonRequestModel({
    this.categoryId,
    this.isActive,
    this.translations,
    this.units,
    this.images,
  });

  CommonRequestModel copyWith({
    int? categoryId,
    bool? isActive,
    List<Translation>? translations,
    List<Unit>? units,
    List<Image>? images,
  }) => CommonRequestModel(
    categoryId: categoryId ?? this.categoryId,
    isActive: isActive ?? this.isActive,
    translations: translations ?? this.translations,
    units: units ?? this.units,
    images: images ?? this.images,
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
                : List<Unit>.from(json["units"]!.map((x) => Unit.fromJson(x))),
        images:
            json["images"] == null
                ? []
                : List<Image>.from(
                  json["images"]!.map((x) => Image.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "is_active": isActive,
    "translations":
        translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x.toJson())),
    "units":
        units == null ? [] : List<dynamic>.from(units!.map((x) => x.toJson())),
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class Image {
  final String? imageUrl;
  final bool? isPrimary;
  final int? displayOrder;

  Image({this.imageUrl, this.isPrimary, this.displayOrder});

  Image copyWith({String? imageUrl, bool? isPrimary, int? displayOrder}) =>
      Image(
        imageUrl: imageUrl ?? this.imageUrl,
        isPrimary: isPrimary ?? this.isPrimary,
        displayOrder: displayOrder ?? this.displayOrder,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imageUrl: json["image_url"],
    isPrimary: json["is_primary"],
    displayOrder: json["display_order"],
  );

  Map<String, dynamic> toJson() => {
    "image_url": imageUrl,
    "is_primary": isPrimary,
    "display_order": displayOrder,
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

class Unit {
  final int? unitId;
  final String? name;
  final String? abbreviation;
  final int? conversionFactor;
  final int? mrp;
  final int? sellingPrice;
  final int? inStock;
  final bool? isDefault;

  Unit({
    this.unitId,
    this.name,
    this.abbreviation,
    this.conversionFactor,
    this.mrp,
    this.sellingPrice,
    this.inStock,
    this.isDefault,
  });

  Unit copyWith({
    int? unitId,
    String? name,
    String? abbreviation,
    int? conversionFactor,
    int? mrp,
    int? sellingPrice,
    int? inStock,
    bool? isDefault,
  }) => Unit(
    unitId: unitId ?? this.unitId,
    name: name ?? this.name,
    abbreviation: abbreviation ?? this.abbreviation,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    mrp: mrp ?? this.mrp,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    inStock: inStock ?? this.inStock,
    isDefault: isDefault ?? this.isDefault,
  );

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
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
