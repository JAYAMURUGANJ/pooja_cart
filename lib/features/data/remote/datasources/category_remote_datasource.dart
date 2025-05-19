import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/request/common_request_model.dart';
import '../model/response/category/category_response_model.dart';

abstract class CategoryRemoteDatasource {
  Future<List<CategoryResponseModel>> getCategory(CommonRequestModel request);
  Future<CategoryResponseModel> createCategory(CommonRequestModel request);
  Future<CategoryResponseModel> updateCategory(CommonRequestModel request);
  Future<String> deleteCategory(CommonRequestModel request);
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

  @override
  Future<CategoryResponseModel> createCategory(CommonRequestModel request) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<String> deleteCategory(CommonRequestModel request) async {
    try {
      final response = await dioClient.delete(
        path: ApiRoutes.deleteCategory,
        queryParameters: {'id': request.categoryId},
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
  Future<CategoryResponseModel> updateCategory(CommonRequestModel request) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
