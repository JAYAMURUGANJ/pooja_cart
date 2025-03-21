part of 'product_bloc.dart';

class ProductEvent {}

class GetProductEvent extends ProductEvent {
  final CommonRequestModel requestData;
  GetProductEvent(this.requestData);
}

class CreateProductEvent extends ProductEvent {
  final CommonRequestModel requestData;
  CreateProductEvent(this.requestData);
}

class UpdateProductEvent extends ProductEvent {
  final CommonRequestModel requestData;
  UpdateProductEvent(this.requestData);
}

class DeleteProductEvent extends ProductEvent {
  final CommonRequestModel requestData;
  DeleteProductEvent(this.requestData);
}
