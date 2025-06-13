import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/usecase/admin/admin_report/get_admin_report_data_usecase.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../domain/entities/admin/admin_report/admin_report_response.dart';

part 'admin_report_data_event.dart';
part 'admin_report_data_state.dart';

class AdminReportDataBloc
    extends Bloc<AdminReportDataEvent, AdminReportDataState> {
  final GetAdminReportDataUseCase _getReportDataUseCase;
  AdminReportDataBloc(this._getReportDataUseCase)
    : super(AdminReportDataState()) {
    on<GetReportDataEvent>(_getReportData);
  }

  _getReportData(
    GetReportDataEvent event,
    Emitter<AdminReportDataState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AdminReportDataStatus.loading));
      final result = await _getReportDataUseCase(event.requestData);
      emit(
        result.fold(
          (failure) => state.copyWith(
            status: AdminReportDataStatus.error,
            errorMsg: failure.message,
          ),
          (dashboardResponse) => state.copyWith(
            status: AdminReportDataStatus.loaded,
            reportResponse: dashboardResponse,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminReportDataStatus.error,
          errorMsg: e.toString(),
        ),
      );
    }
  }
}
