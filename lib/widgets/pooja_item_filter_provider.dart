import 'package:flutter/material.dart';

class FilterProvider extends InheritedWidget {
  final int? selectedCategoryId;
  final int? selectedFunctionCategoryId;
  final Function(int?) onCategoryChanged;
  final Function(int?) onFunctionChanged;
  final VoidCallback onClearFilters;

  const FilterProvider({
    super.key,
    required this.selectedCategoryId,
    required this.selectedFunctionCategoryId,
    required this.onCategoryChanged,
    required this.onFunctionChanged,
    required this.onClearFilters,
    required super.child,
  });

  static FilterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FilterProvider>();
  }

  @override
  bool updateShouldNotify(covariant FilterProvider oldWidget) {
    return selectedCategoryId != oldWidget.selectedCategoryId ||
        selectedFunctionCategoryId != oldWidget.selectedFunctionCategoryId;
  }
}
