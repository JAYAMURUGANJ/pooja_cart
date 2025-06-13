part of 'admin_report_data_bloc.dart';

enum AdminReportDataStatus { initial, loading, loaded, error }

class AdminReportDataState {
  final AdminReportDataStatus status;
  final AdminReportResponse? reportResponse;
  final String? errorMsg;
  const AdminReportDataState({
    this.status = AdminReportDataStatus.initial,
    this.reportResponse,
    this.errorMsg,
  });

  AdminReportDataState copyWith({
    AdminReportDataStatus? status,
    AdminReportResponse? reportResponse,
    String? errorMsg,
  }) {
    return AdminReportDataState(
      status: status ?? this.status,
      reportResponse: reportResponse ?? this.reportResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
