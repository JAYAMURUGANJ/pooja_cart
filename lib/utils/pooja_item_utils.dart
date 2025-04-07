import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';
import 'package:pooja_cart/models/pooja_items_units.dart';

import '../features/domain/entities/place_order/place_order_response.dart';
import '../models/pooja_cart_item.dart';
import '../models/pooja_category_unit_mapping.dart';
import '../models/pooja_items.dart';

class ProductUtils {
  //get Unit name
  String getUnitName(int unitId, List<PoojaUnits> unitList) {
    final unit = unitList.firstWhere(
      (u) => u.id == unitId,
      orElse: () => PoojaUnits(unitName: 'Unknown'),
    );
    return unit.unitSymbol ?? 'Unknown';
  }

  // Filter items based filters
  static List<ProductResponse> getFilteredItems({
    required List<ProductResponse> items,
    required TextEditingController searchController,
    List<int>? selectedCategoryIds,
    List<int>? selectedUnitIds,
  }) {
    String searchQuery = searchController.text.toLowerCase();
    return items.where((item) {
      // Search query filter
      bool matchesSearch =
          searchQuery.isEmpty ||
          (item.name?.toLowerCase().contains(searchQuery) ?? false);
      // Category filter
      bool matchesCategory =
          selectedCategoryIds == null ||
          selectedCategoryIds.isEmpty ||
          (item.categoryId != null &&
              selectedCategoryIds.contains(item.categoryId));

      return matchesSearch && matchesCategory;
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

  static showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Navigate to order summary screen
  static void viewOrderSummary(
    BuildContext context,
    List<OrderItems> cartItems,
  ) {
    if (cartItems.isEmpty) {
      showMessage(context, 'Please add items to cart first');
      return;
    }
    context.go("/cart");

    // Navigator.of(
    //   context,
    // ).push(MaterialPageRoute(builder: (context) => OrderSummaryScreen()));
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

  // Create "Add" button for items not in cart

  // Generate WhatsApp order summary text
  static String generateOrderSummary(PlaceOrderResponse orderResponse) {
    List<PlacedOrderItem> cartItems = orderResponse.orderItems!;
    final StringBuffer summary =
        StringBuffer()
          ..writeln('*POOJA ITEMS ORDER SUMMARY*')
          ..writeln('--------------------------------')
          ..writeln('*Order #:* ${orderResponse.orderReference ?? "N/A"}')
          ..writeln(
            '*Date:* ${orderResponse.orderDate?.toLocal().toString().split(' ')[0] ?? "N/A"}',
          )
          ..writeln('*Status:* ${orderResponse.orderStatus ?? "N/A"}')
          ..writeln('--------------------------------');

    // Shipping Details
    if (orderResponse.shippingDetails != null) {
      summary
        ..writeln('*SHIPPING TO:*')
        ..writeln(orderResponse.shippingDetails!.name ?? "N/A")
        ..writeln(orderResponse.shippingDetails!.shippingAddress ?? "N/A")
        ..writeln('Phone: ${orderResponse.shippingDetails!.mobileNo ?? "N/A"}');
      if (orderResponse.shippingDetails!.email != null) {
        summary.writeln('Email: ${orderResponse.shippingDetails!.email}');
      }
      summary.writeln('--------------------------------');
    }

    // Order Items
    for (int i = 0; i < cartItems.length; i++) {
      final PlacedOrderItem item = cartItems[i];
      double itemtotal = (item.sellingPrice! * item.quantity!);
      double itemdiscount = (item.mrp! - item.sellingPrice!) * item.quantity!;
      summary
        ..writeln('${i + 1}. *${item.productName}*')
        ..writeln(
          '   Qty: ${item.quantity} × ₹${item.sellingPrice!.toStringAsFixed(2)} = ₹${itemtotal.toStringAsFixed(2)}',
        );
      if (itemdiscount > 0) {
        summary.writeln('   Saved: ₹${(itemdiscount).toStringAsFixed(2)}');
      }
      summary.writeln('');
    }

    // Order Summary
    summary
      ..writeln('--------------------------------')
      ..writeln(
        '*Subtotal (MRP):* ₹${orderResponse.subTotal!.toStringAsFixed(2)}',
      );

    if (orderResponse.discount! > 0) {
      double discountPercentage =
          ((orderResponse.subTotal! - orderResponse.total!) /
              orderResponse.subTotal!) *
          100;
      summary.writeln(
        '*Discount(${discountPercentage.toStringAsFixed(1)}%):* ₹${orderResponse.discount!.toStringAsFixed(2)}',
      );
      if (orderResponse.couponCode != null) {
        summary.writeln('  (Coupon: ${orderResponse.couponCode})');
      }
    }

    if (orderResponse.shippingCost! > 0) {
      summary.writeln(
        '*Shipping:* ₹${orderResponse.shippingCost!.toStringAsFixed(2)}',
      );
    }

    if (orderResponse.tax! > 0) {
      summary.writeln('*Tax:* ₹${orderResponse.tax!.toStringAsFixed(2)}');
    }

    summary
      ..writeln('*TOTAL:* ₹${orderResponse.total!.toStringAsFixed(2)}')
      ..writeln('--------------------------------');

    // Payment Method
    if (orderResponse.paymentDetails != null) {
      summary.writeln(
        '*Payment Method:* ${orderResponse.paymentDetails!.paymentMethod ?? "N/A"}',
      );
      if (orderResponse.paymentDetails!.transactionId != null) {
        summary.writeln(
          '*Transaction ID:* ${orderResponse.paymentDetails!.transactionId}',
        );
      }
      summary.writeln('--------------------------------');
    }

    // Order Notes
    if (orderResponse.orderNotes != null &&
        orderResponse.orderNotes!.isNotEmpty) {
      summary
        ..writeln('*ORDER NOTES:*')
        ..writeln(orderResponse.orderNotes!)
        ..writeln('--------------------------------');
    }

    summary.writeln('Thank you for your order! 🙏');
    return summary.toString();
  }

  // Mobile cart footer widget
}
