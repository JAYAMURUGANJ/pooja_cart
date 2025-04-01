import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/usecase/category/get_category_usecase.dart';

import '../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../domain/entities/category/category_response.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryUseCase _getCategoryUseCase;
  CategoryBloc(this._getCategoryUseCase) : super(CategoryState()) {
    on<GetCategoryEvent>(_getAllCategory);
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
}
