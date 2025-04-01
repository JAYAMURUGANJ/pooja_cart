part of 'place_order_bloc.dart';

enum PlaceOrderStatus { intial, loading, loaded, error }

class PlaceOrderState {
  final PlaceOrderStatus status;
  final PlaceOrderResponse? placeOrderResponse;
  final String? errorMsg;

  const PlaceOrderState({
    this.status = PlaceOrderStatus.intial,
    this.placeOrderResponse,
    this.errorMsg,
  });

  PlaceOrderState copyWith({
    PlaceOrderStatus? status,
    final PlaceOrderResponse? placeOrderResponse,
    String? errorMsg,
  }) {
    return PlaceOrderState(
      status: status ?? this.status,
      placeOrderResponse: placeOrderResponse ?? this.placeOrderResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
