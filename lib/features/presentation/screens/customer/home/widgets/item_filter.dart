import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/category/category_response.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/category/category_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/cubit/category_filter_selection/category_filter_selection_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/cubit/unit_filter_selection/unit_filter_selection_cubit.dart';

import '../../../../../../models/pooja_item_functions.dart';
import '../../../../common_widgets/head_container.dart';
import '../cubit/product_filter/product_filter_cubit.dart';

class ItemFilter extends StatefulWidget {
  final Function(Set<int> categoryIds, Set<int> functionIds, Set<int> unitIds)
  onFilterApplied;
  final bool isInline;
  final List<ProductResponse> productList;

  const ItemFilter({
    required this.onFilterApplied,
    this.isInline = true,
    super.key,
    required this.productList,
  });

  @override
  State<ItemFilter> createState() => _ItemFilterState();
}

class _ItemFilterState extends State<ItemFilter> {
  final List<int> _selectedCategoryIds = [];
  final List<int> _selectedFunctionIds = [];

  final List<CategoryUnit> _selectedCategoryUnits = [];

  // late List<CategoryResponse> pCategories;
  late List<PoojaItemFunctions> pFunctions;
  late List<CategoryUnit> pUnits;

  // Track available units based on selected categories
  final List<int> _availableUnitIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isInline ? _buildInlineFilter() : _buildModalFilter();
  }

  Widget _buildInlineFilter() {
    return Container(
      width: 260,
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                // IconButton(
                //   onPressed: hasFiltersApplied ? _clearAllFilters : null,
                //   icon: Icon(
                //     hasFiltersApplied ? Icons.filter_alt_off : Icons.filter_alt,
                //     color: hasFiltersApplied ? Colors.red : Colors.grey,
                //   ),
                //   tooltip: hasFiltersApplied ? 'Clear all filters' : 'Filters',
                // ),
              ],
            ),
          ),
          Expanded(
            child: ListView(children: [_buildCategoryWithUnitsSection()]),
          ),
        ],
      ),
    );
  }

  Widget _buildModalFilter() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter Pooja Items",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          if (_selectedCategoryIds.isNotEmpty ||
              _selectedFunctionIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () {
                BlocProvider.of<ProductFilterCubit>(
                  context,
                ).resetFilter(widget.productList);
              },
              tooltip: 'Clear all filters',
            ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Close',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  children: [
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case CategoryStatus.intial:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case CategoryStatus.loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case CategoryStatus.loaded:
                          
                          case CategoryStatus.error:
                            return Center(child: Text(state.errorMsg!));
                        }
                      },
                    ),

                    // Only show units section if categories are selected
                    if (_selectedCategoryIds.isNotEmpty)
                      _buildFilterSection(
                        title: 'Units',
                        items: pUnits,
                        availableIds: _availableUnitIds,
                      ),
                    if (_selectedCategoryIds.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Select a category to view available units',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedCategoryIds.isNotEmpty ||
                _selectedFunctionIds.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Clear All Filters'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _buildCategoryWithUnitsSection() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        switch (state.status) {
          case CategoryStatus.intial:
            return const Center(child: CircularProgressIndicator());
          case CategoryStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case CategoryStatus.loaded:
            return BlocBuilder<
              CategoryFilterSelectionCubit,
              CategoryFilterSelectionState
            >(
              builder: (context, categorySelectionState) {
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (categorySelectionState.status ==
                          CategoryFilterSelectionStatus.selected)
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<CategoryFilterSelectionCubit>(
                              context,
                            ).resetCategorySelection();
                            BlocProvider.of<ProductFilterCubit>(
                              context,
                            ).resetFilter(widget.productList);
                          },
                          icon: Icon(Icons.close),
                        ),
                    ],
                  ),
                  initiallyExpanded: false, // Expand if no functions selected
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children:
                            state.categoryResponse!.map((category) {
                              final bool isSelectedCategory =
                                  categorySelectionState.status ==
                                          CategoryFilterSelectionStatus.selected
                                      ? categorySelectionState
                                              .categoryResponse!
                                              .id ==
                                          category.id
                                      : false;

                              return ChoiceChip(
                                label: Text(
                                  category.name ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isSelectedCategory
                                            ? Colors.white
                                            : Colors.black87,
                                  ),
                                ),
                                selected: isSelectedCategory,
                                showCheckmark: false,
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                onSelected: (value) {
                                  BlocProvider.of<CategoryFilterSelectionCubit>(
                                    context,
                                  ).selectCategory(category);
                                  BlocProvider.of<ProductFilterCubit>(
                                    context,
                                  ).filterProduct(
                                    products: widget.productList,
                                    selectedCategory: category,
                                  );
                                },
                                backgroundColor: Colors.grey.shade200,
                              );
                            }).toList(),
                      ),
                    ),

                    // Only show units section if categories are selected
                    if (categorySelectionState.status ==
                        CategoryFilterSelectionStatus.selected)
                      _buildUnitSelectionWidget(
                        categorySelectionState,
                        context,
                      ),

                    if (categorySelectionState.status !=
                        CategoryFilterSelectionStatus.selected)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Text(
                          'Select a category to \nview available units',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );

          default:
            return Text("default");
        }
      },
    );
  }

  Widget _buildUnitSelectionWidget(
    CategoryFilterSelectionState categorySelectionState,
    BuildContext context,
  ) {
    List<CategoryUnit> units = categorySelectionState.categoryResponse!.units!;
    return BlocBuilder<UnitFilterSelectionCubit, UnitFilterSelectionState>(
      builder: (context, unitFilterSelectionState) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Units',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                if (unitFilterSelectionState.status ==
                    UnitFilterSelectionStatus.selected)
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<UnitFilterSelectionCubit>(
                        context,
                      ).resetUnitSelection();
                    },
                    icon: Icon(Icons.close),
                  ),
              ],
            ),
            initiallyExpanded: true,
            children: [
              if (units.isEmpty)
                Center(
                  child: Text(
                    'No units available for the selected category',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children:
                        units.map((unit) {
                          final bool isSelected =
                              unitFilterSelectionState.status ==
                                      UnitFilterSelectionStatus.selected
                                  ? unitFilterSelectionState.unitResponse!.id ==
                                      unit.id
                                  : false;

                          return ChoiceChip(
                            label: Text(
                              unit.name ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            onSelected: (value) {
                              BlocProvider.of<UnitFilterSelectionCubit>(
                                context,
                              ).selectUnit(unit);
                              BlocProvider.of<ProductFilterCubit>(
                                context,
                              ).filterProduct(
                                products: widget.productList,
                                selectedCategory:
                                    categorySelectionState.categoryResponse,
                              );
                            },
                            backgroundColor: Colors.grey.shade200,
                            disabledColor: Colors.grey.shade100,
                          );
                        }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<dynamic> items,
    List<int>? availableIds,
  }) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          IconButton(
            onPressed: () {
              BlocProvider.of<ProductFilterCubit>(
                context,
              ).resetFilter(widget.productList);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      initiallyExpanded: false, // Start with Functions expanded
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                items.map((item) {
                  // Fixed: Use the correct property name based on the item type
                  final String itemName =
                      title == 'Units' ? item.unitName : item.name ?? '';
                  final int itemId = item.id;
                  final bool isSelected = true;

                  // Determine if the item should be enabled based on availability
                  bool isEnabled = true;
                  if (title == 'Units' && availableIds != null) {
                    isEnabled = availableIds.contains(itemId);
                  }

                  return ChoiceChip(
                    label: Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isSelected
                                ? Colors.white
                                : isEnabled
                                ? Colors.black87
                                : Colors.grey.shade400,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    onSelected: isEnabled ? (_) {} : null,
                    backgroundColor:
                        isEnabled ? Colors.grey.shade200 : Colors.grey.shade100,
                    disabledColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color:
                          isSelected
                              ? Colors.white
                              : isEnabled
                              ? Colors.black87
                              : Colors.grey.shade400,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
