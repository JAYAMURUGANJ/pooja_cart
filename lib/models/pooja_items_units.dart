class PoojaUnits {
  int? id;
  String? unitName;
  String? unitSymbol;
  String? description;

  PoojaUnits({this.id, this.unitName, this.unitSymbol, this.description});

  PoojaUnits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    unitSymbol = json['unit_symbol'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit_name'] = unitName;
    data['unit_symbol'] = unitSymbol;
    data['description'] = description;
    return data;
  }

  static List<PoojaUnits> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PoojaUnits.fromJson(json)).toList();
  }
}
