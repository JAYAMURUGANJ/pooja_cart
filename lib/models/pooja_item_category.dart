class PoojaItemCategory {
  int? id;
  String? name;
  String? description;

  PoojaItemCategory({this.id, this.name, this.description});

  PoojaItemCategory.fromJson(Map<String, dynamic> json) {
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

  static List<PoojaItemCategory> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PoojaItemCategory.fromJson(json)).toList();
  }
}
