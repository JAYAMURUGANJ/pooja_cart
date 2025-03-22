part of 'product_bloc.dart';

enum ProductStatus { intial, loading, loaded, error }

class ProductState {
  final ProductStatus status;
  final List<ProductResponse>? productResponse;
  final String? errorMsg;

  const ProductState({
    this.status = ProductStatus.intial,
    this.productResponse,
    this.errorMsg,
  });

  ProductState copyWith({
    ProductStatus? status,
    final List<ProductResponse>? productResponse,
    String? errorMsg,
  }) {
    return ProductState(
      status: status ?? this.status,
      productResponse: productResponse ?? this.productResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
