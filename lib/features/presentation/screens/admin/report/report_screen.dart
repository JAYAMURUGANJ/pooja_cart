import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_report/admin_report_response.dart';
import 'package:pooja_cart/features/presentation/screens/admin/report/bloc/admin_report_data/admin_report_data_bloc.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminReportDataBloc>(
      context,
    ).add(GetReportDataEvent(requestData: CommonRequestModel()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report')),
      body: BlocConsumer<AdminReportDataBloc, AdminReportDataState>(
        listener: (context, state) {
          switch (state.status) {
            case AdminReportDataStatus.initial:
              break;
            case AdminReportDataStatus.loading:
            case AdminReportDataStatus.loaded:
            case AdminReportDataStatus.error:
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case AdminReportDataStatus.initial:
            case AdminReportDataStatus.loading:
              return CircularProgressIndicator.adaptive();
            case AdminReportDataStatus.loaded:
              AdminReportResponse data = state.reportResponse!;
              return Column(
                children: [Text(data.summary!.totalOrders!.toString())],
              );
            case AdminReportDataStatus.error:
              return Text("error");
          }
        },
      ),
    );
  }
}
