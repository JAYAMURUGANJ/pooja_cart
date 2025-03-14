class PoojaCategoryUnitMapping {
  int categoryId;
  List<int> unitIds;

  PoojaCategoryUnitMapping({required this.categoryId, required this.unitIds});

  // Factory method to create an object from JSON
  factory PoojaCategoryUnitMapping.fromJson(Map<String, dynamic> json) {
    return PoojaCategoryUnitMapping(
      categoryId: json['category_id'],
      unitIds: List<int>.from(json['unit_ids']),
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {'category_id': categoryId, 'unit_ids': unitIds};
  }

  static List<PoojaCategoryUnitMapping> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PoojaCategoryUnitMapping.fromJson(json))
        .toList();
  }
}
