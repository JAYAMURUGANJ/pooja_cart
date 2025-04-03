import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/presentation/common_widgets/alert_widgets.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/category/category_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/unit/unit_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/cubit/unit_selection/unit_selection_cubit.dart';

import '/constants/category.dart';
import '/constants/function.dart';
import '/constants/unit.dart';
import '/utils/pooja_item_utils.dart';
import '/utils/responsive_utils.dart';
import '../../../domain/entities/order_items/order_items.dart';
import '../../../domain/entities/product/product_response.dart';
import '../order_summary/order_summary_screen.dart';
import 'cubit/order_items/order_items_cubit.dart';
import 'widgets/add_item_to_cart_btn.dart';
import 'widgets/item_filter.dart';
import 'widgets/item_info.dart';
import 'widgets/mobile_cart_footer.dart';
import 'widgets/quantity_controller.dart';
import 'widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  List<int>? selectedCategoryId;
  List<int>? selectedFunctionCategoryId;
  List<int>? selectedUnitId;
  final unitSelectionCubit = UnitSelectionCubit();

  @override
  void initState() {
    BlocProvider.of<UnitBloc>(context).add(GetUnitsEvent(CommonRequestModel()));
    BlocProvider.of<ProductBloc>(
      context,
    ).add(GetProductEvent(CommonRequestModel()));
    BlocProvider.of<CategoryBloc>(
      context,
    ).add(GetCategoryEvent(CommonRequestModel()));
    super.initState();
    searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Scaffold(
      body: _buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<OrderItemsCubit, OrderItemsState>(
        builder: (context, orderState) {
          return isMobile && orderState.orderItems.isNotEmpty
              ? MobileCartFooter(
                context: context,
                orderItems: orderState.orderItems,
                onViewCart:
                    () => ProductUtils.viewOrderSummary(
                      context,
                      orderState.orderItems,
                    ),
              )
              : const SizedBox();
        },
      ),
    );
  }

  Widget _buildBody() {
    // Use ResponsiveUtils.responsiveLayout for layout switching
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        switch (state.status) {
          case ProductStatus.error:
            break;
          case ProductStatus.loaded:
            unitSelectionCubit.initializeDefaultUnits(state.productResponse!);
            break;
          default:
        }
      },
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
              tabletLayout: _buildTabletLayout(productsList),
              desktopLayout: _buildDesktopLayout(productsList),
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
    // Map<String, double> orderSummary,
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
        OrderSummaryScreen(showHeader: true),
      ],
    );
  }

  // Desktop layout
  Widget _buildDesktopLayout(
    List<ProductResponse> productList,
    // Map<String, double> orderSummary,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemFilter(
          poojaItemCategory: poojaItemCategory,
          poojaFunctions: poojaItemFunctions,
          poojaItemUnits: poojaItemUnits,
          categoryUnitMapping: ProductUtils.convertMappingListToMap([]),
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
        OrderSummaryScreen(showHeader: true),
      ],
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
              ProductUtils.clearFilters(
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
              allItems: [] /* pItems */,
              onSearch: (query) {
                setState(() {});
              },
              onItemSelected: (item) {
                // addItemToCart(item);
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
            categoryUnitMapping: ProductUtils.convertMappingListToMap([]),
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

  Widget _showItemGrid(List<ProductResponse> productList) {
    final isMobileView = context.isMobile;

    // Use ResponsiveUtils for grid columns and aspect ratio
    int crossAxisCount = context.gridColumns;
    double aspectRatio = context.gridAspectRatio;

    // Get filtered items
    final filteredItems = ProductUtils.getFilteredItems(
      items: productList,
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
            // int quantity = itemQuantities[item.id] ?? 0;
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
                    pUnits: productList,
                    useWideLayout: false,
                    unitSelectionCubit: unitSelectionCubit,
                  ),
                  SizedBox(height: context.standardSpacing),
                  _buildItemFooter(item, context, unitSelectionCubit),
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
            final unitSelectionCubit = UnitSelectionCubit();
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
                      pUnits: productList,
                      unitSelectionCubit: unitSelectionCubit,
                    ),
                    const Spacer(),
                    Divider(color: Colors.grey.shade200),
                    _buildItemFooter(item, context, unitSelectionCubit),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildItemFooter(
    ProductResponse item,
    BuildContext context,
    UnitSelectionCubit unitSelectionCubit,
  ) {
    return BlocConsumer<UnitSelectionCubit, UnitSelectionState>(
      bloc: unitSelectionCubit,
      listener: (context, state) {},
      builder: (context, unitState) {
        final selectedUnit =
            unitState.selectedUnits[item.id] ??
            item.units!.firstWhere(
              (unit) => unit.isDefault == 1,
              orElse: () => item.units!.first,
            );

        return BlocBuilder<OrderItemsCubit, OrderItemsState>(
          builder: (context, orderState) {
            final orderItemsCubit = context.read<OrderItemsCubit>();

            final isAdded = orderState.orderItems.any(
              (orderItem) =>
                  orderItem.productId == item.id &&
                  orderItem.unitId == selectedUnit.unitId,
            );
            final currentItemQuantity =
                orderState.orderItems
                    .firstWhere(
                      (orderItem) =>
                          orderItem.productId == item.id &&
                          orderItem.unitId == selectedUnit.unitId,
                      orElse:
                          () => OrderItems(
                            productId: item.id!,
                            name: item.name!,
                            unitId: selectedUnit.unitId!,
                            quantity: 0,
                            sellingPrice: selectedUnit.sellingPrice,
                            mrp: selectedUnit.mrp,
                          ),
                    )
                    .quantity!;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedUnit.mrp != null &&
                        selectedUnit.sellingPrice != null &&
                        selectedUnit.mrp! > selectedUnit.sellingPrice!)
                      Text(
                        "₹${selectedUnit.mrp!.toStringAsFixed(2)}",
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
                      "₹${selectedUnit.sellingPrice!.toStringAsFixed(2)}",
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
                isAdded
                    ? QuantityController(
                      quantity: currentItemQuantity,
                      onQuantityChanged: (newQuantity) {
                        if (newQuantity <= 0) {
                          AlertWidgets(context).showCommonAlertDialog(
                            content: "Are you sure want to remove from cart?",
                            actionBtnTxt: "Remove",
                            action: () {
                              orderItemsCubit.removeOrderItem(
                                item.id!,
                                selectedUnit.unitId!,
                              );
                            },
                          );
                        } else {
                          orderItemsCubit.updateQuantity(
                            item.id!,
                            selectedUnit.unitId!,
                            newQuantity,
                          );
                          // Update quantity logic if needed
                        }
                      },
                      width: 100,
                    )
                    : AddItemToCartBtn(
                      itemId: selectedUnit.unitId!,
                      onQuantityChanged: (itemId, newValue) {
                        orderItemsCubit.addOrderItem(
                          OrderItems(
                            productId: item.id!,
                            name: item.name!,
                            unitId: selectedUnit.unitId!,
                            quantity: 1,
                            sellingPrice: selectedUnit.sellingPrice,
                            mrp: selectedUnit.mrp,
                          ),
                        );
                      },
                    ),
              ],
            );
          },
        );
      },
    );
  }
}
