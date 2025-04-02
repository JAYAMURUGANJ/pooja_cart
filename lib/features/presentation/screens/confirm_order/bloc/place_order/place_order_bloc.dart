import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/usecase/place_order/create_place_order_usecase.dart';

import '../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../domain/entities/place_order/place_order_response.dart';

part 'place_order_event.dart';
part 'place_order_state.dart';

class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  final CreatePlaceOrderUseCase _createPlaceOrderUseCase;
  PlaceOrderBloc(this._createPlaceOrderUseCase) : super(PlaceOrderState()) {
    on<ResetPlaceOrderEvent>(_resetInitial);
    on<CreatePlaceOrderEvent>(_createPlaceOrder);
  }
  _resetInitial(ResetPlaceOrderEvent event, Emitter<PlaceOrderState> emit) {
    emit(state.copyWith(status: PlaceOrderStatus.intial));
  }

  _createPlaceOrder(
    CreatePlaceOrderEvent event,
    Emitter<PlaceOrderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PlaceOrderStatus.loading));
      final result = await _createPlaceOrderUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: PlaceOrderStatus.error,
            errorMsg: failure.message,
          ),
          (placeOrderResponse) => state.copyWith(
            status: PlaceOrderStatus.loaded,
            placeOrderResponse: placeOrderResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PlaceOrderStatus.error, errorMsg: e.toString()),
      );
    }
  }
}
