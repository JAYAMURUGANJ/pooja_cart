part of 'place_order_bloc.dart';

class PlaceOrderEvent {}

class GetPlaceOrderEvent extends PlaceOrderEvent {
  final CommonRequestModel requestData;
  GetPlaceOrderEvent(this.requestData);
}

class CreatePlaceOrderEvent extends PlaceOrderEvent {
  final CommonRequestModel requestData;
  CreatePlaceOrderEvent(this.requestData);
}

class UpdatePlaceOrderEvent extends PlaceOrderEvent {
  final CommonRequestModel requestData;
  UpdatePlaceOrderEvent(this.requestData);
}

class DeletePlaceOrderEvent extends PlaceOrderEvent {
  final CommonRequestModel requestData;
  DeletePlaceOrderEvent(this.requestData);
}

class ResetPlaceOrderEvent extends PlaceOrderEvent {
  ResetPlaceOrderEvent();
}
