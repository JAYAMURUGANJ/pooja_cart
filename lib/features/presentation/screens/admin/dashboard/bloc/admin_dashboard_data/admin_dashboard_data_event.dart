part of 'admin_dashboard_data_bloc.dart';

class AdminDashboardDataEvent {}

class GetDashboardDataEvent extends AdminDashboardDataEvent {
  final CommonRequestModel requestData;
  GetDashboardDataEvent({required this.requestData});
}
