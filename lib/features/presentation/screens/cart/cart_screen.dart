import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/data/remote/model/common_request_model.dart';
import 'package:pooja_cart/features/presentation/screens/cart/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/cart/bloc/unit/unit_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '/constants/category.dart';
import '/constants/function.dart';
import '/constants/items.dart';
import '/constants/mapping.dart';
import '/constants/unit.dart';
import '/models/pooja_cart_item.dart';
import '/models/pooja_category_unit_mapping.dart';
import '/models/pooja_item_category.dart';
import '/models/pooja_item_functions.dart';
import '/models/pooja_items.dart';
import '/models/pooja_items_units.dart';
import '/utils/pooja_item_utils.dart';
import '/utils/responsive_utils.dart';
import '../../../domain/entities/product/product_response.dart';
import '../../common_widgets/head_container.dart';
import '../../common_widgets/nav_bar.dart';
import 'widgets/add_item_to_cart_btn.dart';
import 'widgets/empty_cart.dart';
import 'widgets/item_filter.dart';
import 'widgets/item_info.dart';
import 'widgets/mobile_cart_footer.dart';
import 'widgets/quantity_controller.dart';
import 'widgets/search_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
    BlocProvider.of<UnitBloc>(context).add(GetUnitsEvent(CommonRequestModel()));
    BlocProvider.of<ProductBloc>(
      context,
    ).add(GetProductEvent(CommonRequestModel()));
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
    final isMobile = context.isMobile;
    final totalItems = itemQuantities.values.fold(0, (sum, qty) => sum + qty);

    return Scaffold(
      appBar: _appBar(context),
      body: _buildResponsiveLayout(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          isMobile && totalItems > 0
              ? MobileCartFooter(
                context: context,
                totalItems: totalItems,
                total: PoojaItemUtils.getTotal(itemQuantities, pItems),
                onViewCart: viewOrderSummary,
              )
              : null,
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final isDesktopOrWeb = context.isDesktop;

    return AppBar(
      toolbarHeight: context.responsiveValue(mobile: 70.0, desktop: 80.0),
      title:
          isDesktopOrWeb
              ? WebNavBar(
                currentRoute: '/',
                onItemSelected:
                    addItemToCart, // Pass this function to WebNavBar
              )
              : AppTitle(),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      actions: [
        if (context.isMobile)
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: context.responsiveIconSize,
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

    // Use ResponsiveUtils.responsiveLayout for layout switching
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ProductStatus.error:
            return Text("Error loading products");
          case ProductStatus.loaded:
            List<ProductResponse> productsList = state.productResponse!;
            return ResponsiveUtils.responsiveLayout(
              context: context,
              mobileLayout: _buildMobileLayout(productsList),
              tabletLayout: _buildTabletLayout(productsList, orderSummary),
              desktopLayout: _buildDesktopLayout(productsList, orderSummary),
            );
          default:
            return Text("initial");
        }
      },
    );
  }

  // Mobile layout
  Widget _buildMobileLayout(List<ProductResponse> productsList) {
    return Column(
      children: [
        _searchAndFilterBarWithButton(context),
        if (_isAnyFilterApplied()) _clearFilter(),
        Expanded(child: _showItemGrid(productsList)),
      ],
    );
  }

  // Tablet layout
  Widget _buildTabletLayout(
    List<ProductResponse> productList,
    Map<String, double> orderSummary,
  ) {
    final contentSidebarRatio = context.contentSidebarRatio;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: contentSidebarRatio[0],
          child: Column(
            children: [
              _searchAndFilterBarWithButton(context),
              if (_isAnyFilterApplied()) _clearFilter(),
              Expanded(child: _showItemGrid(productList)),
            ],
          ),
        ),
        Container(width: 1, color: Colors.grey.shade200),
        // _orderSummary(productList, orderSummary),
      ],
    );
  }

  // Desktop layout
  Widget _buildDesktopLayout(
    List<ProductResponse> productList,
    Map<String, double> orderSummary,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemFilter(
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
        Container(width: 1, color: Colors.grey.shade200),
        Expanded(flex: 4, child: _showItemGrid(productList)),
        Container(width: 1, color: Colors.grey.shade200),
        // _orderSummary(productList, orderSummary),
      ],
    );
  }

  Widget _orderSummary(
    List<CartItem> cartItems,
    Map<String, double> orderSummary,
  ) {
    final contentSidebarRatio = context.contentSidebarRatio;

    return Expanded(
      flex: contentSidebarRatio[1],
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            _orderSummaryHead(),
            _orderSummaryBody(cartItems),
            if (cartItems.isNotEmpty)
              _buildOrderSummaryFooter(
                orderSummary['mrpTotal']!,
                orderSummary['discount']!,
                orderSummary['total']!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _orderSummaryHead() {
    return HeadContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: context.responsiveFontSize(mobile: 18, desktop: 22),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: context.responsiveIconSize,
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

  Expanded _orderSummaryBody(List<CartItem> cartItems) {
    return Expanded(
      child:
          cartItems.isEmpty
              ? EmptyCart(context: context)
              : ListView.builder(
                padding: context.responsivePadding,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return _buildCartItemTile(cartItem);
                },
              ),
    );
  }

  Widget _buildCartItemTile(CartItem cartItem) {
    final item = cartItem.item;
    final double itemTotal =
        (item.sellingPrice! * cartItem.quantity).toDouble();
    final double itemMrpTotal = (item.mrp! * cartItem.quantity).toDouble();
    final double discountTotal = (itemMrpTotal - itemTotal).toDouble();

    return Container(
      margin: EdgeInsets.only(bottom: context.standardSpacing),
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
        padding: context.responsivePadding,
        child: Column(
          children: [
            // Item and unit
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
                      fontSize: context.responsiveFontSize(
                        mobile: 13,
                        desktop: 15,
                      ),
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
                      fontSize: context.responsiveFontSize(
                        mobile: 12,
                        desktop: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.standardSpacing / 2),
            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "(₹${item.sellingPrice!.toStringAsFixed(2)} × ${cartItem.quantity})",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: context.responsiveFontSize(
                      mobile: 12,
                      desktop: 14,
                    ),
                  ),
                ),
                Text(
                  "₹${itemTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsiveFontSize(
                      mobile: 15,
                      desktop: 17,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.standardSpacing / 2),
            // Quantity controls
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
                        fontSize: context.responsiveFontSize(
                          mobile: 10,
                          desktop: 12,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                QuantityController(
                  itemId: cartItem.item.id!,
                  quantity: cartItem.quantity,
                  onQuantityChanged: updateQuantity,
                  width: 100,
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
  ) {
    return Container(
      padding: context.responsivePadding.copyWith(
        top: context.standardSpacing * 1.5,
        bottom: context.standardSpacing * 1.5,
      ),
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
        children: [
          // MRP total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal (MRP)",
                style: TextStyle(
                  fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "₹${subtotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: context.standardSpacing / 2),
          // If discount available
          if (discount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discount",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: context.responsiveFontSize(
                      mobile: 14,
                      desktop: 16,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "-₹${discount.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontSize: context.responsiveFontSize(
                      mobile: 14,
                      desktop: 16,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          Divider(color: Colors.grey.shade300, thickness: 1),
          SizedBox(height: context.standardSpacing / 2),
          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "₹${total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.standardSpacing),
          // Share WhatsApp button
          SizedBox(
            width: double.infinity,
            height: context.controlHeight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopify_sharp, color: Colors.white),
              label: Text(
                "Confirm Order",
                style: TextStyle(
                  fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
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

  bool _isAnyFilterApplied() {
    return (selectedCategoryId != null && selectedCategoryId!.isNotEmpty) ||
        (selectedFunctionCategoryId != null &&
            selectedFunctionCategoryId!.isNotEmpty) ||
        (selectedUnitId != null && selectedUnitId!.isNotEmpty);
  }

  Widget _clearFilter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.standardSpacing * 2,
        0,
        context.standardSpacing * 2,
        context.standardSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Applied Filters:",
            style: TextStyle(
              fontSize: context.responsiveFontSize(mobile: 13, desktop: 14),
              color: Colors.grey.shade700,
            ),
          ),
          Chip(
            label: Text(
              "${selectedCategoryId!.length + selectedFunctionCategoryId!.length + selectedUnitId!.length} Clear",
              style: TextStyle(
                fontSize: context.responsiveFontSize(mobile: 11, desktop: 12),
              ),
            ),
            deleteIcon: Icon(
              Icons.clear,
              size: context.responsiveValue(mobile: 14.0, desktop: 16.0),
            ),
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

  Widget _searchAndFilterBarWithButton(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: Row(
        children: [
          // Search field
          Expanded(
            child: ItemSearchAnchor(
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
          SizedBox(width: context.standardSpacing),
          // Filter button to show bottom sheet
          Card(
            child: IconButton(
              onPressed: () => _showFilterBottomSheet(context),
              icon: Icon(Icons.filter_list, size: context.responsiveIconSize),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(context.standardSpacing),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          child: ItemFilter(
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

  Future<void> _shareOrderViaWhatsApp(BuildContext context) async {
    final cartItems = getCartItems();
    if (cartItems.isEmpty) {
      PoojaItemUtils.showMessage(context, 'Your order is empty');
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
          PoojaItemUtils.showMessage(context, 'Could not launch WhatsApp.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        PoojaItemUtils.showMessage(context, 'Error opening WhatsApp: $e');
      }
    }
  }

  Widget _showItemGrid(List<ProductResponse> productList) {
    final isMobileView = context.isMobile;

    // Use ResponsiveUtils for grid columns and aspect ratio
    int crossAxisCount = context.gridColumns;
    double aspectRatio = context.gridAspectRatio;

    // Get filtered items
    final filteredItems = PoojaItemUtils.getFilteredItems(
      pItems: productList,
      searchController: searchController,
      selectedCategoryIds: selectedCategoryId,
      selectedItemsFunctionIds: selectedFunctionCategoryId,
      selectedUnitIds: selectedUnitId,
    );

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 70, color: Colors.grey[300]),
            SizedBox(height: context.standardSpacing),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: context.standardSpacing / 2),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
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
              padding: EdgeInsets.symmetric(
                vertical: context.standardSpacing,
                horizontal: context.standardSpacing * 1.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item info row
                  ItemNameImgUnit(
                    item: item,
                    pUnits: pUnits,
                    useWideLayout: false,
                  ),
                  SizedBox(height: context.standardSpacing),
                  // Price information row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "₹${item.sellingPrice}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.responsiveFontSize(
                                mobile: 14,
                                desktop: 16,
                              ),
                            ),
                          ),
                          if (item.mrp != null &&
                              item.sellingPrice != null &&
                              item.mrp! > item.sellingPrice!) ...[
                            const SizedBox(width: 6),
                            Text(
                              "₹${item.mrp}",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                                fontSize: context.responsiveFontSize(
                                  mobile: 11,
                                  desktop: 13,
                                ),
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
                                  fontSize: context.responsiveFontSize(
                                    mobile: 10,
                                    desktop: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      quantity > 0
                          ? QuantityController(
                            itemId: item.id!,
                            quantity: quantity,
                            onQuantityChanged: updateQuantity,
                            width: 100,
                          )
                          : AddItemToCartBtn(
                            itemId: item.id!,
                            onQuantityChanged: updateQuantity,
                          ),
                    ],
                  ),
                ],
              ),
            );
          },
        )
        : GridView.builder(
          padding: EdgeInsets.all(context.standardSpacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: context.standardSpacing,
            mainAxisSpacing: context.standardSpacing,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            final int quantity = itemQuantities[item.id] ?? 0;

            return Card(
              child: Padding(
                padding: context.responsivePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ItemNameImgUnit(
                      item: item,
                      useWideLayout: context.isDesktop || context.isTablet,
                      pUnits: pUnits,
                    ),
                    const Spacer(),
                    Divider(color: Colors.grey.shade200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.mrp != null &&
                                item.sellingPrice != null &&
                                item.mrp! > item.sellingPrice!)
                              Text(
                                "₹${item.mrp?.toStringAsFixed(2)}",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade500,
                                  fontSize: context.responsiveFontSize(
                                    mobile: 12,
                                    desktop: 13,
                                  ),
                                ),
                              ),
                            Text(
                              "₹${item.sellingPrice?.toStringAsFixed(2) ?? '-'}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: context.responsiveFontSize(
                                  mobile: 15,
                                  desktop: 16,
                                ),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        quantity > 0
                            ? QuantityController(
                              itemId: item.id!,
                              quantity: quantity,
                              onQuantityChanged: updateQuantity,
                              width: 100,
                            )
                            : AddItemToCartBtn(
                              itemId: item.id!,
                              onQuantityChanged: updateQuantity,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
