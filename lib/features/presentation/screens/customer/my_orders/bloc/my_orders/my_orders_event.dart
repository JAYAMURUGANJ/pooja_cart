part of 'my_orders_bloc.dart';

class MyOrdersEvent {}

class GetMyOrdersByIdEvent extends MyOrdersEvent {
  final CommonRequestModel requestData;
  GetMyOrdersByIdEvent(this.requestData);
}

class GetMyOrdersByMobileEvent extends MyOrdersEvent {
  final CommonRequestModel requestData;
  GetMyOrdersByMobileEvent(this.requestData);
}
