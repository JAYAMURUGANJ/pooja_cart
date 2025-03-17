import 'package:flutter/material.dart';

import '../models/pooja_item_category.dart';
import '../models/pooja_item_functions.dart';
import '../models/pooja_items_units.dart';
import 'head_container.dart';

class ItemFilter extends StatefulWidget {
  final List<dynamic> poojaItemCategory;
  final List<dynamic> poojaFunctions;
  final List<dynamic> poojaItemUnits;
  final Function(Set<int> categoryIds, Set<int> functionIds, Set<int> unitIds)
  onFilterApplied;
  final bool isInline;
  // Add a new parameter for category-unit mapping
  final Map<int, List<int>> categoryUnitMapping;

  const ItemFilter({
    required this.poojaItemCategory,
    required this.poojaFunctions,
    required this.poojaItemUnits,
    required this.onFilterApplied,
    required this.categoryUnitMapping, // Add this required parameter
    this.isInline = true,
    super.key,
  });

  @override
  State<ItemFilter> createState() => _ItemFilterState();
}

class _ItemFilterState extends State<ItemFilter> {
  final List<int> _selectedCategoryIds = [];
  final List<int> _selectedFunctionIds = [];
  final List<int> _selectedUnitIds = [];

  late List<PoojaItemCategory> pCategories;
  late List<PoojaItemFunctions> pFunctions;
  late List<PoojaUnits> pUnits;

  // Track available units based on selected categories
  List<int> _availableUnitIds = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didUpdateWidget(ItemFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if data sources have changed
    if (widget.poojaItemCategory != oldWidget.poojaItemCategory ||
        widget.poojaFunctions != oldWidget.poojaFunctions ||
        widget.poojaItemUnits != oldWidget.poojaItemUnits ||
        widget.categoryUnitMapping != oldWidget.categoryUnitMapping) {
      _initializeData();
    }
  }

  void _initializeData() {
    pCategories = PoojaItemCategory.fromJsonList(widget.poojaItemCategory);
    pFunctions = PoojaItemFunctions.fromJsonList(widget.poojaFunctions);
    pUnits = PoojaUnits.fromJsonList(widget.poojaItemUnits);
    _updateAvailableUnits();
  }

  // Update available units based on selected categories
  void _updateAvailableUnits() {
    _availableUnitIds = [];

    // If no categories selected, no units are available
    if (_selectedCategoryIds.isEmpty) {
      // Clear any selected units
      _selectedUnitIds.clear();
    } else {
      // Collect all unit IDs for selected categories
      for (int categoryId in _selectedCategoryIds) {
        if (widget.categoryUnitMapping.containsKey(categoryId)) {
          _availableUnitIds.addAll(widget.categoryUnitMapping[categoryId]!);
        }
      }

      // Remove duplicates
      _availableUnitIds = _availableUnitIds.toSet().toList();

      // Remove any selected units that are no longer available
      _selectedUnitIds.removeWhere(
        (unitId) => !_availableUnitIds.contains(unitId),
      );
    }
  }

  void _toggleCategory(int categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId);
      } else {
        _selectedCategoryIds.add(categoryId);
      }
      // Update available units whenever categories change
      _updateAvailableUnits();
    });
    _applyFilters();
  }

  void _toggleFunction(int functionId) {
    setState(() {
      // If the function is already selected, deselect it
      if (_selectedFunctionIds.contains(functionId)) {
        _selectedFunctionIds.remove(functionId);
      } else {
        // Clear any previously selected functions (single selection)
        _selectedFunctionIds.clear();
        // Add the new function
        _selectedFunctionIds.add(functionId);

        // Clear all selected categories when a function is selected
        _selectedCategoryIds.clear();

        // Since categories are cleared, also clear units and available units
        _selectedUnitIds.clear();
        _availableUnitIds = [];
      }
    });
    _applyFilters();
  }

  void _toggleUnit(int unitId) {
    // Only toggle if the unit is available based on selected categories
    if (_availableUnitIds.contains(unitId) ||
        _selectedUnitIds.contains(unitId)) {
      setState(() {
        if (_selectedUnitIds.contains(unitId)) {
          _selectedUnitIds.remove(unitId);
        } else {
          _selectedUnitIds.add(unitId);
        }
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    widget.onFilterApplied(
      _selectedCategoryIds.toSet(),
      _selectedFunctionIds.toSet(),
      _selectedUnitIds.toSet(),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategoryIds.clear();
      _selectedFunctionIds.clear();
      _selectedUnitIds.clear();
      _availableUnitIds = [];
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isInline ? _buildInlineFilter() : _buildModalFilter();
  }

  Widget _buildInlineFilter() {
    final bool hasFiltersApplied =
        _selectedCategoryIds.isNotEmpty ||
        _selectedFunctionIds.isNotEmpty ||
        _selectedUnitIds.isNotEmpty;

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
                IconButton(
                  onPressed: hasFiltersApplied ? _clearAllFilters : null,
                  icon: Icon(
                    hasFiltersApplied ? Icons.filter_alt_off : Icons.filter_alt,
                    color: hasFiltersApplied ? Colors.red : Colors.grey,
                  ),
                  tooltip: hasFiltersApplied ? 'Clear all filters' : 'Filters',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildFilterSection(
                  title: 'Functions',
                  items: pFunctions,
                  selectedIds: _selectedFunctionIds,
                  onToggle: _toggleFunction,
                ),
                _buildCategoryWithUnitsSection(),
              ],
            ),
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
              _selectedFunctionIds.isNotEmpty ||
              _selectedUnitIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: _clearAllFilters,
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
                    _buildFilterSection(
                      title: 'Functions',
                      items: pFunctions,
                      selectedIds: _selectedFunctionIds,
                      onToggle: _toggleFunction,
                    ),
                    _buildFilterSection(
                      title: 'Categories',
                      items: pCategories,
                      selectedIds: _selectedCategoryIds,
                      onToggle: _toggleCategory,
                    ),

                    // Only show units section if categories are selected
                    if (_selectedCategoryIds.isNotEmpty)
                      _buildFilterSection(
                        title: 'Units',
                        items: pUnits,
                        selectedIds: _selectedUnitIds,
                        onToggle: _toggleUnit,
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
                _selectedFunctionIds.isNotEmpty ||
                _selectedUnitIds.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _clearAllFilters,
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

  Widget _buildCategoryWithUnitsSection() {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (_selectedCategoryIds.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedCategoryIds.clear();
                  _selectedUnitIds.clear();
                  _availableUnitIds = [];
                });
                _applyFilters();
              },
              icon: Icon(Icons.close),
            ),
        ],
      ),
      initiallyExpanded: false, // Expand if no functions selected
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                pCategories.map((category) {
                  final bool isSelected = _selectedCategoryIds.contains(
                    category.id,
                  );

                  return ChoiceChip(
                    label: Text(
                      category.name ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    onSelected: (_) => _toggleCategory(category.id!),
                    backgroundColor: Colors.grey.shade200,
                  );
                }).toList(),
          ),
        ),

        // Only show units section if categories are selected
        if (_selectedCategoryIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Units',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  if (_selectedUnitIds.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedUnitIds.clear();
                        });
                        _applyFilters();
                      },
                      icon: Icon(Icons.close),
                    ),
                ],
              ),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children:
                        pUnits.map((unit) {
                          final bool isSelected = _selectedUnitIds.contains(
                            unit.id,
                          );
                          final bool isEnabled = _availableUnitIds.contains(
                            unit.id,
                          );

                          return ChoiceChip(
                            label: Text(
                              unit.unitName ?? '',
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
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            onSelected:
                                isEnabled ? (_) => _toggleUnit(unit.id!) : null,
                            backgroundColor:
                                isEnabled
                                    ? Colors.grey.shade200
                                    : Colors.grey.shade100,
                            disabledColor: Colors.grey.shade100,
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

        if (_selectedCategoryIds.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
  }

  Widget _buildFilterSection({
    required String title,
    required List<dynamic> items,
    required List<int> selectedIds,
    required Function(int) onToggle,
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
          if (selectedIds.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  selectedIds.clear();
                  if (title == 'Categories') {
                    // Clear units when categories are cleared
                    _selectedUnitIds.clear();
                    _availableUnitIds = [];
                  }
                });
                _applyFilters();
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
                  final bool isSelected = selectedIds.contains(itemId);

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
                    onSelected: isEnabled ? (_) => onToggle(itemId) : null,
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
