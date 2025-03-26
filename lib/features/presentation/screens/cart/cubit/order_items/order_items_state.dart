part of 'order_items_cubit.dart';

enum OrderItemsStatus { initial, updated }

class OrderItemsState {
  final OrderItemsStatus status;
  final List<OrderItems> orderItems;

  OrderItemsState({
    this.status = OrderItemsStatus.initial,
    this.orderItems = const [],
  });

  OrderItemsState copyWith({
    OrderItemsStatus? status,
    List<OrderItems>? orderItems,
  }) {
    return OrderItemsState(
      status: status ?? this.status,
      orderItems: orderItems ?? this.orderItems,
    );
  }
}
