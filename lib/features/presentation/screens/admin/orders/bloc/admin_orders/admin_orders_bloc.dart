import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_orders/admin_orders_response.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../domain/usecase/admin/admin_orders/get_admin_orders_usecase.dart';

part 'admin_orders_event.dart';
part 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final GetAdminOrdersUseCase _getAdminOrdersUseCase;
  AdminOrdersBloc(this._getAdminOrdersUseCase) : super(AdminOrdersState()) {
    on<GetAllOrdersEvent>(_getAllOrders);
  }

  _getAllOrders(GetAllOrdersEvent event, Emitter<AdminOrdersState> emit) async {
    try {
      emit(state.copyWith(status: AdminOrdersStatus.loading));
      final result = await _getAdminOrdersUseCase(event.requestData);
      print("bloc result is $result");
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: AdminOrdersStatus.error,
            errorMsg: failure.message,
          ),
          (getAdminOrdersResponse) => state.copyWith(
            status: AdminOrdersStatus.loaded,
            ordersResponse: getAdminOrdersResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AdminOrdersStatus.error, errorMsg: e.toString()),
      );
    }
  }
}
