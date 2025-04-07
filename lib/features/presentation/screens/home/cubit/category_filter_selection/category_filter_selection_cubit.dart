import 'package:bloc/bloc.dart';

import '../../../../../domain/entities/category/category_response.dart';

part 'category_filter_selection_state.dart';

class CategoryFilterSelectionCubit extends Cubit<CategoryFilterSelectionState> {
  CategoryFilterSelectionCubit() : super(CategoryFilterSelectionState());

  selectCategory(CategoryResponse category) {
    emit(
      CategoryFilterSelectionState().copyWith(
        status: CategoryFilterSelectionStatus.selected,
        categoryResponse: category,
      ),
    );
  }

  resetCategorySelection() {
    emit(
      CategoryFilterSelectionState().copyWith(
        status: CategoryFilterSelectionStatus.unSelected,
        categoryResponse: null,
      ),
    );
  }
}
