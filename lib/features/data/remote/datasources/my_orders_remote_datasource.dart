import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/request/common_request_model.dart';
import '../model/response/my_orders/my_orders_response_model.dart';

abstract class MyOrdersRemoteDatasource {
  Future<List<MyOrdersResponseModel>> getOrderById(CommonRequestModel request);
  Future<List<MyOrdersResponseModel>> getOrderByMobile(
    CommonRequestModel request,
  );
}

class MyOrdersRemoteDatasourceImpl implements MyOrdersRemoteDatasource {
  final DioClient dioClient;
  MyOrdersRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<MyOrdersResponseModel>> getOrderById(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.post(
        path: ApiRoutes.getOrderById,
        data: request.toJson(),
      );
      return (response.data as List)
          .map((e) => MyOrdersResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }

  @override
  Future<List<MyOrdersResponseModel>> getOrderByMobile(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.post(
        path: ApiRoutes.getOrderById,
        data: request.toJson(),
      );
      return (response.data as List)
          .map((e) => MyOrdersResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
