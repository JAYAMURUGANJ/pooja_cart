part of 'admin_orders_bloc.dart';

class AdminOrdersEvent {}

class GetAllOrdersEvent extends AdminOrdersEvent {
  final CommonRequestModel requestData;
  GetAllOrdersEvent(this.requestData);
}

class CreateOrderEvent extends AdminOrdersEvent {
  final CommonRequestModel requestData;
  CreateOrderEvent(this.requestData);
}

class UpdateOrderEvent extends AdminOrdersEvent {
  final CommonRequestModel requestData;
  UpdateOrderEvent(this.requestData);
}

class DeleteOrderEvent extends AdminOrdersEvent {
  final CommonRequestModel requestData;
  DeleteOrderEvent(this.requestData);
}
