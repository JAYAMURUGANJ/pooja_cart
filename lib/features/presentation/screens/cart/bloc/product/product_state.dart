part of 'product_bloc.dart';

enum ProductStatus { intial, loading, loaded, error }

class ProductState {
  final ProductStatus status;
  final List<ProductResponse>? unitResponse;
  final String? errorMsg;

  const ProductState({
    this.status = ProductStatus.intial,
    this.unitResponse,
    this.errorMsg,
  });

  ProductState copyWith({
    ProductStatus? status,
    final List<ProductResponse>? productResponse,
    String? errorMsg,
  }) {
    return ProductState(
      status: status ?? this.status,
      unitResponse: productResponse ?? this.unitResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
