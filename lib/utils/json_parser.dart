import 'dart:convert';

import '../models/pooja_item_category.dart';
import '../models/pooja_item_functions.dart';
import '../models/pooja_items.dart';

class JsonParser {
  static List<PoojaItems> parsePoojaItems(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return PoojaItems.fromJsonList(jsonList);
  }

  static List<PoojaItemCategory> parsePoojaCategories(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return PoojaItemCategory.fromJsonList(jsonList);
  }

  static List<PoojaItemFunctions> parsePoojaFunctions(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return PoojaItemFunctions.fromJsonList(jsonList);
  }
}
