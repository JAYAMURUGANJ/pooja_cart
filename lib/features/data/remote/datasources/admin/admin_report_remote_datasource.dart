import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../model/request/common_request_model.dart';
import '../../model/response/admin/admin_report/admin_report_response_model.dart';

abstract class AdminReportRemoteDatasource {
  Future<AdminReportResponseModel> getAdminReportData(
    CommonRequestModel request,
  );
}

class AdminReportRemoteDatasourceImpl implements AdminReportRemoteDatasource {
  final DioClient dioClient;
  AdminReportRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<AdminReportResponseModel> getAdminReportData(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.get(
        path: ApiRoutes.getAdminReportData,
        queryParameters: {'report_type': "A"},
      );
      return AdminReportResponseModel.fromJson(response.data[0]);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
