import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/entities/category/category_response.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

class ProductFilterCubit extends Cubit<List<ProductResponse>> {
  ProductFilterCubit() : super([]);

  void filterProduct(
    List<ProductResponse> products,
    String searchQuery,
    CategoryResponse? selectedCategory,
    int? selectedUnitId,
  ) {
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

    emit(filteredProducts);
  }
}
