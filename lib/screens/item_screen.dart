import 'package:flutter/material.dart';

import '../constants/category.dart';
import '../constants/function.dart';
import '../constants/items.dart';
import '../constants/mapping.dart';
import '../constants/unit.dart';
import '../models/pooja_category_unit_mapping.dart';
import '../models/pooja_item_category.dart';
import '../models/pooja_item_functions.dart';
import '../models/pooja_items.dart';
import '../models/pooja_items_units.dart';
import '../utils/pooja_item_utils.dart';
import '../widgets/pooja_item_filter.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final TextEditingController searchController = TextEditingController();
  List<int>? selectedCategoryId;
  List<int>? selectedFunctionCategoryId;
  List<int>? selectedUnitId;
  final List<PoojaItemCategory> pCategories = PoojaItemCategory.fromJsonList(
    poojaItemCategory,
  );
  final List<PoojaItems> pItems = PoojaItems.fromJsonList(poojaItems);
  final List<PoojaItemFunctions> pFunctions = PoojaItemFunctions.fromJsonList(
    poojaItemFunctions,
  );
  final List<PoojaUnits> unitList = PoojaUnits.fromJsonList(poojaItemUnits);

  final List<PoojaCategoryUnitMapping> categoryUnitMapping =
      PoojaCategoryUnitMapping.fromJsonList(categoryUnitJson);
  final Map<int, int> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateQuantity(int itemId, int change) {
    PoojaItemUtils.updateQuantity(itemQuantities, itemId, change, setState);
  }

  void clearAllItems() {
    setState(() {
      itemQuantities.clear();
    });
  }

  void viewOrderSummary() {
    PoojaItemUtils.viewOrderSummary(
      context,
      itemQuantities,
      pItems,
      updateQuantity,
      clearAllItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = itemQuantities.values.fold(0, (sum, qty) => sum + qty);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pooja Items",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 22),
            onPressed:
                (itemQuantities.isNotEmpty)
                    ? () {
                      PoojaItemUtils.showClearCartDialog(
                        context,
                        clearAllItems,
                      );
                    }
                    : null,
          ),
          IconButton(
            onPressed: (itemQuantities.isNotEmpty) ? viewOrderSummary : null,
            icon:
                (itemQuantities.isNotEmpty)
                    ? Badge.count(
                      count: totalItems,
                      child: const Icon(Icons.shopping_cart),
                    )
                    : const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          _searchAndFilterBar(context),

          // Active filters indicator
          if (selectedCategoryId != null || selectedFunctionCategoryId != null)
            _filterIndicator(),

          // Items list
          _showItemList(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          totalItems > 0
              ? Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: 56,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: viewOrderSummary,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$totalItems ${totalItems == 1 ? 'item' : 'items'}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "₹${PoojaItemUtils.getTotal(itemQuantities, pItems).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "VIEW CART",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Container _searchAndFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade600,
                              size: 16,
                            ),
                            onPressed:
                                () => setState(() => searchController.clear()),
                          )
                          : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder:
                    (context) => PoojaItemFilter(
                      poojaItemCategory: poojaItemCategory,
                      poojaFunctions: poojaItemFunctions,
                      poojaItemUnits: unitList, // ✅ Correct
                      categoryUnitMapping:
                          PoojaItemUtils.convertMappingListToMap(
                            categoryUnitMapping,
                          ),
                      onFilterApplied: (categoryIds, functionIds, unitIds) {
                        setState(() {
                          selectedCategoryId = categoryIds.toList();
                          selectedFunctionCategoryId = functionIds.toList();
                          selectedUnitId = unitIds.toList();
                        });
                      },
                      isInline: false, // Show as sidebar
                    ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    (selectedCategoryId != null ||
                            selectedFunctionCategoryId != null)
                        ? Colors.blue.shade50
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.filter_list,
                color:
                    (selectedCategoryId != null ||
                            selectedFunctionCategoryId != null)
                        ? Colors.blue
                        : Colors.grey.shade700,
                size: 20,
              ),
            ),
          ),
          if (selectedCategoryId != null || selectedFunctionCategoryId != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategoryId = null;
                    selectedFunctionCategoryId = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Container _filterIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.blue.shade50,
      child: Text(
        "Filters applied",
        style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
      ),
    );
  }

  Expanded _showItemList() {
    // Get filtered items based on search and filter criteria
    final filteredItems = PoojaItemUtils.getFilteredItems(
      pItems: pItems,
      searchController: searchController,
      selectedCategoryIds: selectedCategoryId,
      selectedItemsFunctionIds: selectedFunctionCategoryId,
    );

    return Expanded(
      child:
          (filteredItems.isEmpty)
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No items found",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  int quantity = itemQuantities[item.id] ?? 0;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${item.unitCount} ${PoojaItemUtils().getUnitName(item.unitId!, unitList)}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "₹${item.sellingPrice}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (item.mrp! > item.sellingPrice!) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      "₹${item.mrp}",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "${((1 - (item.sellingPrice! / item.mrp!)) * 100).toStringAsFixed(0)}% off",
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        quantity > 0
                            ? PoojaItemUtils.buildQuantityControl(
                              itemId: item.id!,
                              quantity: quantity,
                              onQuantityChanged: updateQuantity,
                            )
                            : PoojaItemUtils.buildAddButton(
                              itemId: item.id!,
                              onQuantityChanged: updateQuantity,
                            ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
