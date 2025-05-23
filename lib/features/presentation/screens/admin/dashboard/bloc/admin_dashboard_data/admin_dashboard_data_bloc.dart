import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/usecase/admin/admin_dashboard/get_admin_dashboard_data_usecase.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

part 'admin_dashboard_data_event.dart';
part 'admin_dashboard_data_state.dart';

class AdminDashboardDataBloc
    extends Bloc<AdminDashboardDataEvent, AdminDashboardDataState> {
  final GetAdminDashboardDataUseCase _getDashboardDataUseCase;
  AdminDashboardDataBloc(this._getDashboardDataUseCase)
    : super(AdminDashboardDataState()) {
    on<GetDashboardDataEvent>(_getDashboardData);
  }

  _getDashboardData(
    GetDashboardDataEvent event,
    Emitter<AdminDashboardDataState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdminDashboardDataStatus.loading));
      final result = await _getDashboardDataUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: AdminDashboardDataStatus.error,
            errorMsg: failure.message,
          ),
          (dashboardResponse) => state.copyWith(
            status: AdminDashboardDataStatus.loaded,
            dashboardResponse: dashboardResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminDashboardDataStatus.error,
          errorMsg: e.toString(),
        ),
      );
    }
  }
}
