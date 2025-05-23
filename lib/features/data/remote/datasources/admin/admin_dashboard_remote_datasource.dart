import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';
import 'package:pooja_cart/features/data/remote/model/response/admin/admin_dashboard/admin_dashboard_response_model.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../model/request/common_request_model.dart';

abstract class AdminDashboardRemoteDatasource {
  Future<AdminDashboardResponseModel> getAdminDashboardData(
    CommonRequestModel request,
  );
}

class AdminDashboardRemoteDatasourceImpl
    implements AdminDashboardRemoteDatasource {
  final DioClient dioClient;
  AdminDashboardRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<AdminDashboardResponseModel> getAdminDashboardData(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.get(
        path: ApiRoutes.getDashboardData,
        queryParameters: {'recent_orders_limit': 3, 'top_limit': 3, "limit": 3},
      );
      return AdminDashboardResponseModel.fromJson(response.data[0]);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
