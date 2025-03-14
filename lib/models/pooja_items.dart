class PoojaItems {
  int? id;
  String? name;
  int? unitId;
  int? unitCount;
  int? itemCategoryId;
  List<int>? itemsFunctionsIds;
  int? mrp;
  int? sellingPrice;
  String? img;

  PoojaItems({
    this.id,
    this.name,
    this.unitId,
    this.unitCount,
    this.itemCategoryId,
    this.itemsFunctionsIds,
    this.mrp,
    this.sellingPrice,
    this.img,
  });

  PoojaItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitId = json['unit_id'];
    unitCount = json['unit_count'];
    itemCategoryId = json['item_category_id'];
    itemsFunctionsIds = json['items_function_ids'].cast<int>();
    mrp = json['mrp'];
    sellingPrice = json['selling_price'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['unit_id'] = unitId;
    data['unit_count'] = unitCount;
    data['item_category_id'] = itemCategoryId;
    data['items_function_ids'] = itemsFunctionsIds;
    data['mrp'] = mrp;
    data['selling_price'] = sellingPrice;
    data['img'] = img;
    return data;
  }

  static List<PoojaItems> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PoojaItems.fromJson(json)).toList();
  }
}
