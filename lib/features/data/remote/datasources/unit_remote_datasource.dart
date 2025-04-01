import 'package:dio/dio.dart';
import 'package:pooja_cart/core/constants/api_routes.dart';
import 'package:pooja_cart/core/network/dio_client.dart';
import 'package:pooja_cart/features/data/remote/model/response/unit/unit_response_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/request/common_request_model.dart';

abstract class UnitRemoteDatasource {
  Future<List<UnitResponseModel>> getUnits(CommonRequestModel request);
}

class UnitRemoteDatasourceImpl implements UnitRemoteDatasource {
  final DioClient dioClient;
  UnitRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<UnitResponseModel>> getUnits(CommonRequestModel request) async {
    try {
      final response = await dioClient.get(path: ApiRoutes.getUnits);
      return (response.data as List)
          .map((e) => UnitResponseModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Something went wrong',
      );
    }
  }
}
