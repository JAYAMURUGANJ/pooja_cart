part of 'admin_report_data_bloc.dart';

class AdminReportDataEvent {
  const AdminReportDataEvent();
}

class GetReportDataEvent extends AdminReportDataEvent {
  final CommonRequestModel requestData;
  GetReportDataEvent({required this.requestData});
}
