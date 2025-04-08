import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/entities/category/category_response.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

class ProductFilterCubit extends Cubit<List<ProductResponse>> {
  ProductFilterCubit() : super([]);

  void filterProduct({
    required List<ProductResponse> products,
    String searchQuery = "",
    CategoryResponse? selectedCategory,
    int? selectedUnitId,
  }) {
    List<ProductResponse> filteredProducts =
        products.where((item) {
          // Search query filter
          final matchesSearch =
              searchQuery.isEmpty ||
              (item.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false);

          // Category filter
          final matchesCategory =
              selectedCategory == null ||
              selectedCategory.id == null ||
              (item.categoryId != null &&
                  item.categoryId == selectedCategory.id);

          // Unit filter (only if a unit is selected)
          final matchesUnit =
              selectedUnitId == null ||
              (item.units?.any((unit) => unit.unitId == selectedUnitId) ??
                  false);

          return matchesSearch && matchesCategory && matchesUnit;
        }).toList();

    // if (selectedUnitId != null) {
    //   filteredProducts =
    //       filteredProducts.where((item) {
    //         return item.units?.any((unit) => unit.unitId == selectedUnitId) ??
    //             false;
    //       }).toList();

    //   // remove unselected units from the filtered products
    //   for (var product in filteredProducts) {
    //     product.units?.removeWhere((unit) => unit.unitId != selectedUnitId);
    //   }
    // }

    if (selectedUnitId != null) {
      // Step 1: Filter products that have at least one matching unit
      filteredProducts =
          filteredProducts.where((product) {
            return product.units?.any(
                  (unit) => unit.unitId == selectedUnitId,
                ) ??
                false;
          }).toList();

      // Step 2: For each remaining product, keep only the selected unit
      filteredProducts =
          filteredProducts.map((product) {
            final filteredUnits =
                product.units
                    ?.where((unit) => unit.unitId == selectedUnitId)
                    .toList();

            // Option 1: If your product class is mutable
            // product.unit = filteredUnits;
            return product;

            // Option 2 (better): If you're using an immutable model
            // return product.copyWith(units: filteredUnits);
          }).toList();
    }

    // If no filters are applied, show all products
    if (searchQuery.isEmpty &&
        selectedCategory == null &&
        selectedUnitId == null) {
      filteredProducts = products;
    } else {
      // If no products match the filters, show an empty list
      if (filteredProducts.isEmpty) {
        filteredProducts = [];
      }
    }

    emit(filteredProducts);
  }

  void resetFilter(List<ProductResponse> products) {
    emit(products);
  }
}
