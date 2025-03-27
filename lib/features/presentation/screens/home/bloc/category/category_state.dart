part of 'category_bloc.dart';

enum CategoryStatus { intial, loading, loaded, error }

class CategoryState {
  final CategoryStatus status;
  final List<CategoryResponse>? categoryResponse;
  final String? errorMsg;

  const CategoryState({
    this.status = CategoryStatus.intial,
    this.categoryResponse,
    this.errorMsg,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    final List<CategoryResponse>? categoryResponse,
    String? errorMsg,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categoryResponse: categoryResponse ?? this.categoryResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
