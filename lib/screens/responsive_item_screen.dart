import 'package:flutter/material.dart';
import 'package:pooja_cart/models/pooja_items_units.dart';
import 'package:pooja_cart/widgets/head_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/category.dart';
import '../constants/function.dart';
import '../constants/items.dart';
import '../constants/mapping.dart';
import '../constants/unit.dart';
import '../models/pooja_cart_item.dart';
import '../models/pooja_category_unit_mapping.dart';
import '../models/pooja_item_category.dart';
import '../models/pooja_item_functions.dart';
import '../models/pooja_items.dart';
import '../utils/pooja_item_utils.dart';
import '../widgets/nav_bar.dart';
import '../widgets/item_filter.dart';
import '../widgets/search_bar.dart';

class ResponsiveItemScreen extends StatefulWidget {
  const ResponsiveItemScreen({super.key});

  @override
  _ResponsiveItemScreenState createState() => _ResponsiveItemScreenState();
}

class _ResponsiveItemScreenState extends State<ResponsiveItemScreen> {
  final TextEditingController searchController = TextEditingController();
  List<int>? selectedCategoryId;
  List<int>? selectedFunctionCategoryId;
  List<int>? selectedUnitId;

  final List<PoojaCategoryUnitMapping> categoryUnitMapping =
      PoojaCategoryUnitMapping.fromJsonList(categoryUnitJson);
  final List<PoojaItemCategory> pCategories = PoojaItemCategory.fromJsonList(
    poojaItemCategory,
  );
  final List<PoojaItems> pItems = PoojaItems.fromJsonList(poojaItems);
  final List<PoojaItemFunctions> pFunctions = PoojaItemFunctions.fromJsonList(
    poojaItemFunctions,
  );
  final List<PoojaUnits> pUnits = PoojaUnits.fromJsonList(poojaItemUnits);

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
    if (MediaQuery.of(context).size.width < 600) {
      PoojaItemUtils.viewOrderSummary(
        context,
        itemQuantities,
        pItems,
        updateQuantity,
        clearAllItems,
      );
    }
  }

  void addItemToCart(PoojaItems item) {
    setState(() {
      int currentQuantity = itemQuantities[item.id] ?? 0;
      itemQuantities[item.id!] = currentQuantity + 1;
    });
  }

  List<CartItem> getCartItems() {
    List<CartItem> cartItems = [];
    itemQuantities.forEach((itemId, quantity) {
      if (quantity > 0) {
        final item = pItems.firstWhere((item) => item.id == itemId);
        cartItems.add(CartItem(item: item, quantity: quantity));
      }
    });
    return cartItems;
  }

  Map<String, double> getOrderSummary() {
    double mrpTotal = 0.0;
    double total = 0.0;

    getCartItems().forEach((cartItem) {
      mrpTotal += cartItem.item.mrp! * cartItem.quantity;
      total += cartItem.item.sellingPrice! * cartItem.quantity;
    });

    return {'mrpTotal': mrpTotal, 'discount': mrpTotal - total, 'total': total};
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktopOrWeb = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;
    final isMobile = size.width <= 600;

    final totalItems = itemQuantities.values.fold(0, (sum, qty) => sum + qty);

    return Scaffold(
      appBar: _appBar(isMobile, isDesktopOrWeb, isTablet, context),
      body: _buildResponsiveLayout(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          isMobile && totalItems > 0
              ? Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: 60,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: viewOrderSummary,
                    borderRadius: BorderRadius.circular(12),
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
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "₹${PoojaItemUtils.getTotal(itemQuantities, pItems).toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "VIEW CART",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 8),
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

  AppBar _appBar(
    bool isMobile,
    bool isDesktopOrWeb,
    bool isTablet,
    BuildContext context,
  ) {
    return AppBar(
      toolbarHeight: 80,
      title: isDesktopOrWeb ? WebNavBar(currentRoute: '/') : AppTitle(),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      actions: [
        if (isMobile)
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: isDesktopOrWeb ? 26 : (isTablet ? 24 : 22),
              color:
                  (itemQuantities.isNotEmpty)
                      ? Colors.red.shade400
                      : Colors.grey.shade400,
            ),
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
      ],
    );
  }

  Widget _buildResponsiveLayout() {
    final orderSummary = getOrderSummary();
    final cartItems = getCartItems();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600 && size.width <= 900;
    final isDesktopOrWeb = size.width > 900;

    // For desktop/web layout with sidebar filter
    if (isDesktopOrWeb) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Filter panel (now includes units)
          // In the _buildResponsiveLayout() method and other places where PoojaItemFilter is used
          PoojaItemFilter(
            poojaItemCategory: poojaItemCategory,
            poojaFunctions: poojaItemFunctions,
            poojaItemUnits: poojaItemUnits,
            categoryUnitMapping: PoojaItemUtils.convertMappingListToMap(
              categoryUnitMapping,
            ),
            onFilterApplied: (categoryIds, functionIds, unitIds) {
              setState(() {
                selectedCategoryId = categoryIds.toList();
                selectedFunctionCategoryId = functionIds.toList();
                selectedUnitId = unitIds.toList();
              });
            },
            isInline: true,
          ),

          // Vertical divider
          Container(width: 1, color: Colors.grey.shade200),

          // Center - Item list view
          Expanded(flex: 4, child: _showItemGrid(isDesktopOrWeb: true)),

          // Vertical divider
          Container(width: 1, color: Colors.grey.shade200),

          // Right side - Order summary
          _orderSummary(true, cartItems, orderSummary),
        ],
      );
    } else if (isTablet) {
      // Tablet layout with filter button to show bottom sheet
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content with filter button
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _searchAndFilterBarWithButton(context),
                if (_isAnyFilterApplied()) _clearFilter(),
                Expanded(child: _showItemGrid(isDesktopOrWeb: false)),
              ],
            ),
          ),

          // Vertical divider
          Container(width: 1, color: Colors.grey.shade200),

          // Right side - Order summary
          _orderSummary(false, cartItems, orderSummary),
        ],
      );
    } else {
      // Mobile layout (single column with bottom sheet for filter)
      return Column(
        children: [
          _searchAndFilterBarWithButton(context),
          if (_isAnyFilterApplied()) _clearFilter(),
          Expanded(child: _showItemGrid(isDesktopOrWeb: false)),
        ],
      );
    }
  }

  /// Helper function to check if any filter is applied
  bool _isAnyFilterApplied() {
    return (selectedCategoryId != null && selectedCategoryId!.isNotEmpty) ||
        (selectedFunctionCategoryId != null &&
            selectedFunctionCategoryId!.isNotEmpty) ||
        (selectedUnitId != null && selectedUnitId!.isNotEmpty);
  }

  Padding _clearFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Applied Filters:",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          Chip(
            label: Text(
              "${selectedCategoryId!.length + selectedFunctionCategoryId!.length + selectedUnitId!.length} Clear",
              style: const TextStyle(fontSize: 12),
            ),
            deleteIcon: const Icon(Icons.clear, size: 16),
            onDeleted: () {
              PoojaItemUtils.clearFilters(
                searchController: searchController,
                setState: setState,

                onFilterReset: (categoryIds, functionIds, unitIds) {
                  selectedCategoryId = categoryIds;
                  selectedFunctionCategoryId = functionIds;
                  selectedUnitId = unitIds;
                },
              );
            },
            backgroundColor: Colors.blue.shade50,
            deleteIconColor: Colors.blue.shade700,
            labelStyle: TextStyle(color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  // Search bar with filter button to show bottom sheet
  Widget _searchAndFilterBarWithButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),

      child: Row(
        spacing: 5,
        children: [
          // Search field
          Expanded(
            child: PoojaItemSearchAnchor(
              allItems: pItems,
              onSearch: (query) {
                setState(() {});
              },
              onItemSelected: (item) {
                addItemToCart(item);
              },
              searchController: searchController,
            ),
          ),
          // Filter button to show bottom sheet
          Card(
            child: IconButton(
              onPressed: () => _showFilterBottomSheet(context),
              icon: const Icon(Icons.filter_list),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show filter as bottom sheet for tablet and mobile
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: PoojaItemFilter(
            poojaItemCategory: poojaItemCategory,
            poojaFunctions: poojaItemFunctions,
            poojaItemUnits: poojaItemUnits,
            categoryUnitMapping: PoojaItemUtils.convertMappingListToMap(
              categoryUnitMapping,
            ),
            onFilterApplied: (categoryIds, functionIds, unitIds) {
              setState(() {
                selectedCategoryId = categoryIds.toList();
                selectedFunctionCategoryId = functionIds.toList();
                selectedUnitId = unitIds.toList();
              });
            },
            isInline: false,
          ),
        );
      },
    );
  }

  Expanded _orderSummary(
    bool isDesktopOrWeb,
    List<CartItem> cartItems,
    Map<String, double> orderSummary,
  ) {
    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            _orderSummaryHead(isDesktopOrWeb),
            _orderSummaryBody(cartItems, isDesktopOrWeb),
            // Order summary footer
            if (cartItems.isNotEmpty)
              _buildOrderSummaryFooter(
                orderSummary['mrpTotal']!,
                orderSummary['discount']!,
                orderSummary['total']!,
                isDesktopOrWeb,
              ),
          ],
        ),
      ),
    );
  }

  Expanded _orderSummaryBody(List<CartItem> cartItems, bool isDesktopOrWeb) {
    return Expanded(
      child:
          cartItems.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isDesktopOrWeb ? 20 : 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Add items from the list',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isDesktopOrWeb ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return _buildCartItemTile(cartItem, isDesktopOrWeb);
                },
              ),
    );
  }

  Widget _orderSummaryHead(bool isDesktopOrWeb) {
    return HeadContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: isDesktopOrWeb ? 22 : 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 22,
              color:
                  (itemQuantities.isNotEmpty)
                      ? Colors.red.shade400
                      : Colors.grey.shade400,
            ),
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
        ],
      ),
    );
  }

  Widget _buildCartItemTile(CartItem cartItem, bool isDesktopOrWeb) {
    final item = cartItem.item;
    final double itemTotal =
        (item.sellingPrice! * cartItem.quantity).toDouble();
    final double itemMrpTotal = (item.mrp! * cartItem.quantity).toDouble();
    final double discountTotal = (itemMrpTotal - itemTotal).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 5,
          children: [
            //item and unit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    item.name!,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktopOrWeb ? 12 : 13,
                      color: Theme.of(context).colorScheme.primary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    "${item.unitCount} ${PoojaItemUtils().getUnitName(item.unitId!, pUnits)}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: isDesktopOrWeb ? 12 : 13,
                    ),
                  ),
                ),
              ],
            ),
            //price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "(₹${item.sellingPrice!.toStringAsFixed(2)} × ${cartItem.quantity})",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: isDesktopOrWeb ? 12 : 13,
                  ),
                ),

                Text(
                  "₹${itemTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isDesktopOrWeb ? 17 : 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            // quantity controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (discountTotal > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "You Save ₹${discountTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isDesktopOrWeb ? 10 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                PoojaItemUtils.buildResponsiveQuantityControl(
                  itemId: cartItem.item.id!,
                  quantity: cartItem.quantity,
                  onQuantityChanged: updateQuantity,
                  buttonSize: 20,
                  fontSize: 14,
                  width: 100, // Explicitly set width to match parent
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryFooter(
    double subtotal,
    double discount,
    double total,
    bool isDesktopOrWeb,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        spacing: 5,
        children: [
          //MRP total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal (MRP)",
                style: TextStyle(
                  fontSize: isDesktopOrWeb ? 16 : 14,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "₹${subtotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: isDesktopOrWeb ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          //if discount avail
          if (discount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discount",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: isDesktopOrWeb ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "-₹${discount.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: isDesktopOrWeb ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          //total amt
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktopOrWeb ? 20 : 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "₹${total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktopOrWeb ? 20 : 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          //share whatsapp btn
          SizedBox(
            width: double.infinity,
            height: isDesktopOrWeb ? 50 : 46,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopify_sharp, color: Colors.white),
              label: Text(
                "Confirm Order",
                style: TextStyle(
                  fontSize: isDesktopOrWeb ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => _shareOrderViaWhatsApp(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareOrderViaWhatsApp(BuildContext context) async {
    final cartItems = getCartItems();
    if (cartItems.isEmpty) {
      _showMessage(context, 'Your order is empty');
      return;
    }

    final orderSummary = getOrderSummary();
    final String whatsappNumber = "9566632370";

    final String orderText = PoojaItemUtils.generateOrderSummary(
      cartItems,
      orderSummary['mrpTotal']!,
      orderSummary['discount']!,
      orderSummary['total']!,
    );
    final String encodedMessage = Uri.encodeComponent(orderText);
    final String formattedNumber = whatsappNumber.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$formattedNumber?text=$encodedMessage',
    );

    try {
      bool launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        if (context.mounted) {
          _showMessage(context, 'Could not launch WhatsApp.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, 'Error opening WhatsApp: $e');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
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

  Widget _showItemGrid({bool isDesktopOrWeb = false}) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600 && size.width <= 900;
    final bool useWideLayout = isDesktopOrWeb || isTablet;
    final bool isMobileView = size.width <= 600;

    // Optimized column count for different screens
    int crossAxisCount =
        (size.width > 1200)
            ? 3
            : (size.width > 800)
            ? 2
            : (size.width > 600)
            ? 2
            : 1;

    // Adjust aspect ratio dynamically
    double aspectRatio = isMobileView ? 1.2 : (useWideLayout ? 1.6 : 1);

    // Get filtered items based on search and filter criteria
    // Get filtered items based on search and filter criteria
    final filteredItems = PoojaItemUtils.getFilteredItems(
      pItems: pItems,
      searchController: searchController,
      selectedCategoryIds: selectedCategoryId,
      selectedItemsFunctionIds: selectedFunctionCategoryId,
      selectedUnitIds: selectedUnitId, // Add this parameter
    );

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 70, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: useWideLayout ? 20 : 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: useWideLayout ? 16 : 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Use a staggered grid view for flexible heights
    return isMobileView
        ? ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            int quantity = itemQuantities[item.id] ?? 0;

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                          "${item.unitCount} ${PoojaItemUtils().getUnitName(item.unitId!, pUnits)}",
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
        )
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            padding: EdgeInsets.all(useWideLayout ? 0 : 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // Remove fixed aspect ratio to allow flexible height
              mainAxisExtent: null,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              final int quantity = itemQuantities[item.id] ?? 0;

              // Use a more flexible container that adapts to content
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Important for flexibility
                    children: [
                      // Item header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? 'Unknown Item',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: useWideLayout ? 14 : 15,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${item.unitCount} ${PoojaItemUtils().getUnitName(item.unitId!, pUnits)}",
                                  style: TextStyle(
                                    fontSize: useWideLayout ? 14 : 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Category tag if available
                          if (item.itemCategoryId != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getCategoryName(item.itemCategoryId!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Flexible spacer
                      const Spacer(),
                      // Divider for visual separation
                      Divider(color: Colors.grey.shade200),
                      // Price and add item controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price information
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Show old price if discount available
                              if (item.mrp != null &&
                                  item.sellingPrice != null &&
                                  item.mrp! > item.sellingPrice!)
                                Text(
                                  "₹${item.mrp?.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade500,
                                    fontSize: useWideLayout ? 13 : 12,
                                  ),
                                ),

                              // Current price
                              Text(
                                "₹${item.sellingPrice?.toStringAsFixed(2) ?? '-'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: useWideLayout ? 16 : 15,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),

                          // Add or quantity controls
                          quantity > 0
                              ? SizedBox(
                                width: 100,
                                child:
                                    PoojaItemUtils.buildResponsiveQuantityControl(
                                      itemId: item.id!,
                                      quantity: quantity,
                                      onQuantityChanged: updateQuantity,
                                      buttonSize: 33,
                                      fontSize: 13,
                                    ),
                              )
                              : SizedBox(
                                height: 36,
                                child: OutlinedButton(
                                  onPressed: () => addItemToCart(item),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }

  // Helper method to get category name from category ID
  String _getCategoryName(int categoryId) {
    final category = pCategories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => PoojaItemCategory(id: categoryId, name: "Category"),
    );
    return category.name ?? "Category";
  }
}
