part of 'admin_orders_bloc.dart';

enum AdminOrdersStatus { initial, loading, loaded, error }

class AdminOrdersState {
  final AdminOrdersStatus status;
  final List<AdminOrdersResponse>? ordersResponse;
  final String? errorMsg;

  const AdminOrdersState({
    this.status = AdminOrdersStatus.initial,
    this.ordersResponse,
    this.errorMsg,
  });

  AdminOrdersState copyWith({
    AdminOrdersStatus? status,
    final List<AdminOrdersResponse>? ordersResponse,
    String? errorMsg,
  }) {
    return AdminOrdersState(
      status: status ?? this.status,
      ordersResponse: ordersResponse ?? this.ordersResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
