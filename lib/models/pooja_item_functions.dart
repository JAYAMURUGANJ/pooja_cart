class PoojaItemFunctions {
  int? id;
  String? name;
  String? description;

  PoojaItemFunctions({this.id, this.name, this.description});

  PoojaItemFunctions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }

  static List<PoojaItemFunctions> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PoojaItemFunctions.fromJson(json)).toList();
  }
}
