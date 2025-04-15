part of 'category_bloc.dart';

class CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {
  final CommonRequestModel requestData;
  GetCategoryEvent(this.requestData);
}

class CreateCategoryEvent extends CategoryEvent {
  final CommonRequestModel requestData;
  CreateCategoryEvent(this.requestData);
}

class UpdateCategoryEvent extends CategoryEvent {
  final CommonRequestModel requestData;
  UpdateCategoryEvent(this.requestData);
}

class DeleteCategoryEvent extends CategoryEvent {
  final CommonRequestModel requestData;
  DeleteCategoryEvent(this.requestData);
}
