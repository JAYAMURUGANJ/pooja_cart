import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/common_request_model.dart';
import '../model/product/product_response_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductResponseModel>> getProducts(CommonRequestModel request);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final DioClient dioClient;
  ProductRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<ProductResponseModel>> getProducts(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.get(path: ApiRoutes.getProducts);
      return (response.data as List)
          .map((e) => ProductResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
