import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/category/category_response_model.dart';
import '../model/common_request_model.dart';

abstract class CategoryRemoteDatasource {
  Future<List<CategoryResponseModel>> getCategory(CommonRequestModel request);
}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final DioClient dioClient;
  CategoryRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<CategoryResponseModel>> getCategory(
    CommonRequestModel request,
  ) async {
    try {
      final response = await dioClient.get(path: ApiRoutes.getCategory);
      return (response.data as List)
          .map((e) => CategoryResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
