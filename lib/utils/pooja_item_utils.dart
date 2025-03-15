import 'package:flutter/material.dart';
import 'package:pooja_cart/models/pooja_items_units.dart';

import '../models/pooja_cart_item.dart';
import '../models/pooja_category_unit_mapping.dart';
import '../models/pooja_items.dart';
import '../screens/order_summary.dart';

class PoojaItemUtils {
  //get Unit name
  String getUnitName(int unitId, List<PoojaUnits> unitList) {
    final unit = unitList.firstWhere(
      (u) => u.id == unitId,
      orElse: () => PoojaUnits(unitName: 'Unknown'),
    );
    return unit.unitSymbol ?? 'Unknown';
  }

  // Filter items based filters
  static List<PoojaItems> getFilteredItems({
    required List<PoojaItems> pItems,
    required TextEditingController searchController,
    List<int>? selectedCategoryIds,
    List<int>? selectedItemsFunctionIds,
    List<int>? selectedUnitIds, // Add this parameter
  }) {
    String searchQuery = searchController.text.toLowerCase();

    return pItems.where((item) {
      // Search query filter
      bool matchesSearch =
          searchQuery.isEmpty ||
          (item.name?.toLowerCase().contains(searchQuery) ?? false);

      // Category filter
      bool matchesCategory =
          selectedCategoryIds == null ||
          selectedCategoryIds.isEmpty ||
          (item.itemCategoryId != null &&
              selectedCategoryIds.contains(item.itemCategoryId));

      // Function filter
      bool matchesFunction =
          selectedItemsFunctionIds == null ||
          selectedItemsFunctionIds.isEmpty ||
          (item.itemsFunctionsIds is List<int> &&
              item.itemsFunctionsIds!.any(
                (id) => selectedItemsFunctionIds.contains(id),
              ));

      // Unit filter - add this block
      bool matchesUnit =
          selectedUnitIds == null ||
          selectedUnitIds.isEmpty ||
          (item.unitId != null && selectedUnitIds.contains(item.unitId));

      return matchesSearch && matchesCategory && matchesFunction && matchesUnit;
    }).toList();
  }

  // Clear search and filters
  static void clearFilters({
    required TextEditingController searchController,
    required Function setState,
    required Function(List<int>?, List<int>?, List<int>?) onFilterReset,
  }) {
    setState(() {
      searchController.clear();
      onFilterReset(null, null, null);
    });
  }

  static Map<int, List<int>> convertMappingListToMap(
    List<PoojaCategoryUnitMapping> mappings,
  ) {
    final Map<int, List<int>> result = {};
    for (var mapping in mappings) {
      if (mapping.categoryId != null && mapping.unitIds != null) {
        result[mapping.categoryId] = mapping.unitIds;
      }
    }
    return result;
  }

  // Update item quantity in cart
  static void updateQuantity(
    Map<int, int> itemQuantities,
    int itemId,
    int change,
    Function setState,
  ) {
    setState(() {
      itemQuantities[itemId] = (itemQuantities[itemId] ?? 0) + change;
      if (itemQuantities[itemId]! <= 0) {
        itemQuantities.remove(itemId);
      }
    });
  }

  // Calculate subtotal based on selling price
  static double getSubtotal(
    Map<int, int> itemQuantities,
    List<PoojaItems> pItems,
  ) {
    return itemQuantities.entries.fold(0, (sum, entry) {
      final item = pItems.firstWhere((i) => i.id == entry.key);
      return sum + (item.sellingPrice! * entry.value);
    });
  }

  // Calculate total MRP
  static double getMrpTotal(
    Map<int, int> itemQuantities,
    List<PoojaItems> pItems,
  ) {
    return itemQuantities.entries.fold(0, (sum, entry) {
      final item = pItems.firstWhere((i) => i.id == entry.key);
      return sum + (item.mrp! * entry.value);
    });
  }

  // Calculate total discount
  static double getDiscount(
    Map<int, int> itemQuantities,
    List<PoojaItems> pItems,
  ) {
    return itemQuantities.entries.fold(0, (sum, entry) {
      final item = pItems.firstWhere((i) => i.id == entry.key);
      return sum + ((item.mrp! - item.sellingPrice!) * entry.value);
    });
  }

  // Calculate final total
  static double getTotal(
    Map<int, int> itemQuantities,
    List<PoojaItems> pItems,
  ) {
    return getSubtotal(itemQuantities, pItems);
  }

  // Get cart items list
  static List<CartItem> getCartItems(
    Map<int, int> itemQuantities,
    List<PoojaItems> pItems,
  ) {
    return itemQuantities.entries.map((entry) {
      final item = pItems.firstWhere((i) => i.id == entry.key);
      return CartItem(item: item, quantity: entry.value);
    }).toList();
  }

  // Navigate to order summary screen
  static void viewOrderSummary(
    BuildContext context,
    Map<int, int> itemQuantities,
    List<PoojaItems> pItems,
    Function(int, int)? onQuantityChanged,
    Function()? onClearOrder,
  ) {
    if (itemQuantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add items to cart first')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => OrderSummaryScreen(
              cartItems: getCartItems(itemQuantities, pItems),
              mrptotal: getMrpTotal(itemQuantities, pItems),
              discount: getDiscount(itemQuantities, pItems),
              total: getTotal(itemQuantities, pItems),
              onQuantityChanged: onQuantityChanged,
              onClearOrder: onClearOrder,
            ),
      ),
    );
  }

  // Show confirmation dialog for clearing cart
  static void showClearCartDialog(BuildContext context, Function() onClear) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text('Are you sure you want to clear your cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onClear();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Create quantity control widget
  static Widget buildQuantityControl({
    required int itemId,
    required int quantity,
    required Function(int, int) onQuantityChanged,
    double? height,
    double? width,
  }) {
    height ??= 32.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: height,
            child: InkWell(
              onTap: () => onQuantityChanged(itemId, -1),
              child: Icon(Icons.remove, size: 16, color: Colors.grey.shade700),
            ),
          ),
          Container(
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 28,
            height: height,
            child: InkWell(
              onTap: () => onQuantityChanged(itemId, 1),
              child: const Icon(Icons.add, size: 16, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  // Create "Add" button for items not in cart
  static Widget buildAddButton({
    required int itemId,
    required Function(int, int) onQuantityChanged,
  }) {
    return OutlinedButton(
      onPressed: () => onQuantityChanged(itemId, 1),
      child: const Text(
        "ADD",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Generate WhatsApp order summary text
  static String generateOrderSummary(
    List<CartItem> cartItems,
    double subtotal,
    double discount,
    double total,
  ) {
    final StringBuffer summary =
        StringBuffer()
          ..writeln('*POOJA ITEMS ORDER SUMMARY*')
          ..writeln('--------------------------------');

    for (int i = 0; i < cartItems.length; i++) {
      final CartItem item = cartItems[i];
      summary
        ..writeln('${i + 1}. *${item.item.name}*')
        ..writeln(
          '   Qty: ${item.quantity} × ₹${item.item.sellingPrice!.toStringAsFixed(2)} = ₹${item.totalPrice.toStringAsFixed(2)}',
        );
      if (item.totalDiscount > 0) {
        summary.writeln('   Saved: ₹${item.totalDiscount.toStringAsFixed(2)}');
      }
      summary.writeln('');
    }

    summary
      ..writeln('--------------------------------')
      ..writeln('*Subtotal (MRP):* ₹${subtotal.toStringAsFixed(2)}');

    if (discount > 0) {
      summary.writeln('*Discount:* ₹${discount.toStringAsFixed(2)}');
    }

    summary
      ..writeln('*TOTAL:* ₹${total.toStringAsFixed(2)}')
      ..writeln('Thank you for your order!');

    return summary.toString();
  }

  static Widget buildResponsiveQuantityControl({
    required int itemId,
    required int quantity,
    required Function(int, int) onQuantityChanged,
    double? height,
    double? width,
    required int buttonSize,
    required int fontSize,
  }) {
    height ??= 32.0;

    // Calculate widths based on available space
    final double iconButtonWidth = buttonSize.toDouble();
    final double quantityWidth = 32.0;

    return Container(
      height: height,
      constraints: BoxConstraints(maxWidth: width ?? double.infinity),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconButtonWidth,
            height: height,
            child: InkWell(
              onTap: () => onQuantityChanged(itemId, -1),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.remove,
                  size: fontSize.toDouble(),
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Container(
            width: quantityWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: fontSize.toDouble(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: iconButtonWidth,
            height: height,
            child: InkWell(
              onTap: () => onQuantityChanged(itemId, 1),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.add,
                  size: fontSize.toDouble(),
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
