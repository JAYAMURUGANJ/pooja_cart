part of 'order_items_cubit.dart';

enum OrderItemsStatus { unSelected, selected, error }

class OrderItemsState {
  final OrderItemsStatus status;
  final List<OrderItems> orderItems;
  final String? error;

  const OrderItemsState({
    this.status = OrderItemsStatus.unSelected,
    this.orderItems = const [],
    this.error,
  });

  OrderItemsState copyWith({
    OrderItemsStatus? status,
    List<OrderItems>? orderItems,
    String? error,
  }) {
    return OrderItemsState(
      status: status ?? this.status,
      orderItems: orderItems ?? this.orderItems,
      error: error ?? this.error,
    );
  }
}
