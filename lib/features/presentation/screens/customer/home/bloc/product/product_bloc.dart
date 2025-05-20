import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/usecase/product/create_product_usecase.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../domain/entities/product/product_response.dart';
import '../../../../../../domain/usecase/product/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase _getProductUseCase;
  final CreateProductUseCase _createProductUseCase;
  ProductBloc(this._getProductUseCase, this._createProductUseCase)
    : super(ProductState()) {
    on<GetProductEvent>(_getAllProducts);
    on<CreateProductEvent>(_createProduct);
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
          (getProductResponse) {
            return state.copyWith(
              status: ProductStatus.loaded,
              productResponse: getProductResponse,
            );
          },
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, errorMsg: e.toString()));
    }
  }

  _createProduct(CreateProductEvent event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final result = await _createProductUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: ProductStatus.error,
            errorMsg: failure.message,
          ),
          (productResponse) => state.copyWith(
            status: ProductStatus.loaded,
            productResponse: state.productResponse!..add(productResponse),
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, errorMsg: e.toString()));
    }
  }
}
