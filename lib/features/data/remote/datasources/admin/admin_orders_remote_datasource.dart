import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../model/request/common_request_model.dart';
import '../../model/response/admin/admin_orders/admin_orders_response_model.dart';

abstract class AdminOrdersRemoteDatasource {
  Future<List<AdminOrdersResponseModel>> getAdminOrders(
    CommonRequestModel request,
  );
  Future<AdminOrdersResponseModel> createAdminOrder(CommonRequestModel request);
  Future<AdminOrdersResponseModel> updateAdminOrder(CommonRequestModel request);
  Future<String> deleteAdminOrder(CommonRequestModel request);
}

class AdminOrdersRemoteDatasourceImpl implements AdminOrdersRemoteDatasource {
  final DioClient dioClient;
  AdminOrdersRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<AdminOrdersResponseModel>> getAdminOrders(
    CommonRequestModel request,
  ) async {
    try {
      print("inside remote datasource");
      final response = await dioClient.get(path: ApiRoutes.getAdminOrders);
      print(" data source response.data: ${response.data}");
      var data =
          (response.data as List)
              .map((e) => AdminOrdersResponseModel.fromJson(e))
              .toList();
      print(data);
      return data;
    } on DioException catch (e) {
      print(e.toString());
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }

  @override
  Future<AdminOrdersResponseModel> createAdminOrder(
    CommonRequestModel request,
  ) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<String> deleteAdminOrder(CommonRequestModel request) async {
    try {
      final response = await dioClient.delete(
        path: ApiRoutes.deleteAdminOrder,
        queryParameters: {'id': request.orderId},
        data: request.toJson(),
      );
      print("response.data: ${response.data}");
      return response.data['id'];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }

  @override
  Future<AdminOrdersResponseModel> updateAdminOrder(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.put(
        path: ApiRoutes.updateAdminOrder,
        data: request.toJson(),
      );
      return AdminOrdersResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
