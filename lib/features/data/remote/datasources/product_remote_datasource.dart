import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/request/common_request_model.dart';
import '../model/response/product/product_response_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductResponseModel>> getProducts(CommonRequestModel request);
  Future<ProductResponseModel> createProduct(CommonRequestModel request);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final DioClient dioClient;
  ProductRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<ProductResponseModel>> getProducts(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.get(path: ApiRoutes.products);
      return (response.data as List)
          .map((e) => ProductResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }

  @override
  Future<ProductResponseModel> createProduct(CommonRequestModel request) async {
    try {
      final response = await dioClient.post(
        path: ApiRoutes.products,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        data: await request.toFormData(),
      );
      return ProductResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
