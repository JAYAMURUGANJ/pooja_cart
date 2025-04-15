import 'package:bloc/bloc.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../domain/entities/product/product_response.dart';
import '../../../../../../domain/usecase/product/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase _getProductUseCase;
  ProductBloc(this._getProductUseCase) : super(ProductState()) {
    on<GetProductEvent>(_getAllProducts);
  }

  _getAllProducts(GetProductEvent event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final result = await _getProductUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: ProductStatus.error,
            errorMsg: failure.message,
          ),
          (getProductResponse) => state.copyWith(
            status: ProductStatus.loaded,
            productResponse: getProductResponse,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, errorMsg: e.toString()));
    }
  }
}
