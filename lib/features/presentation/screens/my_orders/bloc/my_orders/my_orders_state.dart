part of 'my_orders_bloc.dart';

enum MyOrdersStatus { intial, loading, loaded, error }

class MyOrdersState {
  final MyOrdersStatus status;
  final List<MyOrdersResponse>? myOrdersResponse;
  final String? errorMsg;

  const MyOrdersState({
    this.status = MyOrdersStatus.intial,
    this.myOrdersResponse,
    this.errorMsg,
  });

  MyOrdersState copyWith({
    MyOrdersStatus? status,
    final List<MyOrdersResponse>? myOrdersResponse,
    String? errorMsg,
  }) {
    return MyOrdersState(
      status: status ?? this.status,
      myOrdersResponse: myOrdersResponse ?? this.myOrdersResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
