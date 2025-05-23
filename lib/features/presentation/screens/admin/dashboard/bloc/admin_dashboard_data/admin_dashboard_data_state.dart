part of 'admin_dashboard_data_bloc.dart';

enum AdminDashboardDataStatus { initial, loading, loaded, error }

class AdminDashboardDataState {
  final AdminDashboardDataStatus status;
  final AdminDashboardResponse? dashboardResponse;
  final String? errorMsg;

  const AdminDashboardDataState({
    this.status = AdminDashboardDataStatus.initial,
    this.dashboardResponse,
    this.errorMsg,
  });

  AdminDashboardDataState copyWith({
    AdminDashboardDataStatus? status,
    AdminDashboardResponse? dashboardResponse,
    String? errorMsg,
  }) {
    return AdminDashboardDataState(
      status: status ?? this.status,
      dashboardResponse: dashboardResponse ?? this.dashboardResponse,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
