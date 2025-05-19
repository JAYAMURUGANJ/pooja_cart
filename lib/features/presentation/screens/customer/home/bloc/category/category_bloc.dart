import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/usecase/category/delete_category_usecase.dart';
import 'package:pooja_cart/features/domain/usecase/category/get_category_usecase.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../domain/entities/category/category_response.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryUseCase _getCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;
  CategoryBloc(this._getCategoryUseCase, this._deleteCategoryUseCase)
    : super(CategoryState()) {
    on<GetCategoryEvent>(_getAllCategory);
    on<CreateCategoryEvent>(_createCategory);
    on<UpdateCategoryEvent>(_updateCategory);
    on<DeleteCategoryEvent>(_deleteCategory);
  }

  _getAllCategory(GetCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      final result = await _getCategoryUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: CategoryStatus.error,
            errorMsg: failure.message,
          ),
          (getCategoryResponse) => state.copyWith(
            status: CategoryStatus.loaded,
            categoryResponse: getCategoryResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.error, errorMsg: e.toString()),
      );
    }
  }

  Future<void> _deleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      final result = await _deleteCategoryUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: CategoryStatus.error,
            errorMsg: failure.message,
          ),
          (deleteCategoryResponse) => state.copyWith(
            status: CategoryStatus.loaded,
            categoryResponse:
                state.categoryResponse!
                    .where(
                      (element) => element.id != event.requestData.categoryId,
                    )
                    .toList(),
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.error, errorMsg: e.toString()),
      );
    }
  }

  FutureOr<void> _updateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(status: CategoryStatus.loading));
  }

  FutureOr<void> _createCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(state.copyWith(status: CategoryStatus.loading));
  }
}
