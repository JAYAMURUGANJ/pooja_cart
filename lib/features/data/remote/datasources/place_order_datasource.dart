import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/request/common_request_model.dart';
import '../model/response/place_order/place_order_response_model.dart';

abstract class PlaceOrderRemoteDatasource {
  Future<PlaceOrderResponseModel> placeOrder(CommonRequestModel request);
}

class PlaceOrderRemoteDatasourceImpl implements PlaceOrderRemoteDatasource {
  final DioClient dioClient;
  PlaceOrderRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<PlaceOrderResponseModel> placeOrder(CommonRequestModel request) async {
    try {
      final response = await dioClient.post(
        path: ApiRoutes.placeOrder,
        data: request.toJson(),
      );
      return PlaceOrderResponseModel.fromJson(response.data[0]);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
