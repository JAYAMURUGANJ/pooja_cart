import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/usecase/my_orders/get_my_orders_by_id_usecase.dart';

import '../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../domain/entities/my_orders/my_orders_response.dart';
import '../../../../../domain/usecase/my_orders/get_my_orders_by_mobile_usecase.dart';

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final GetMyOrdersByIdUseCase _getMyOrdersByIdUseCase;
  final GetMyOrdersByMobileUseCase _getMyOrdersByMobileUseCase;
  MyOrdersBloc(this._getMyOrdersByIdUseCase, this._getMyOrdersByMobileUseCase)
    : super(MyOrdersState()) {
    on<GetMyOrdersByIdEvent>(_getMyOrdersById);
    on<GetMyOrdersByMobileEvent>(_getMyOrdersByMobile);
  }

  _getMyOrdersById(
    GetMyOrdersByIdEvent event,
    Emitter<MyOrdersState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MyOrdersStatus.loading));
      final result = await _getMyOrdersByIdUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: MyOrdersStatus.error,
            errorMsg: failure.message,
          ),
          (myOrdersResponse) => state.copyWith(
            status: MyOrdersStatus.loaded,
            myOrdersResponse: myOrdersResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MyOrdersStatus.error, errorMsg: e.toString()),
      );
    }
  }

  _getMyOrdersByMobile(
    GetMyOrdersByMobileEvent event,
    Emitter<MyOrdersState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MyOrdersStatus.loading));
      final result = await _getMyOrdersByMobileUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: MyOrdersStatus.error,
            errorMsg: failure.message,
          ),
          (myOrdersResponse) => state.copyWith(
            status: MyOrdersStatus.loaded,
            myOrdersResponse: myOrdersResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MyOrdersStatus.error, errorMsg: e.toString()),
      );
    }
  }
}
