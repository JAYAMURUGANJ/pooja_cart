part of 'category_filter_selection_cubit.dart';

enum CategoryFilterSelectionStatus { unSelected, selected, error }

class CategoryFilterSelectionState {
  final CategoryFilterSelectionStatus status;
  final CategoryResponse? categoryResponse;
  final String? error;
  const CategoryFilterSelectionState({
    this.status = CategoryFilterSelectionStatus.unSelected,
    this.categoryResponse,
    this.error,
  });

  CategoryFilterSelectionState copyWith({
    CategoryFilterSelectionStatus? status,
    CategoryResponse? categoryResponse,
    String? error,
  }) {
    return CategoryFilterSelectionState(
      status: status ?? this.status,
      categoryResponse: categoryResponse ?? this.categoryResponse,
      error: error ?? this.error,
    );
  }
}
