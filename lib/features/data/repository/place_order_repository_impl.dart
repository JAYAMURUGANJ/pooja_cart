import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/place_order/place_order_response.dart';
import '../../domain/repository/place_order_repository.dart';
import '../remote/datasources/place_order_datasource.dart';

class PlaceOrderRepositoryImpl implements PlaceOrderRepository {
  final PlaceOrderRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  PlaceOrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, PlaceOrderResponse>> createPlaceOrder(
    CommonRequestModel request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.placeOrder(request);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> deletePlaceOrder(CommonRequestModel request) {
    // TODO: implement deletePlaceOrder
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PlaceOrderResponse>>> getPlaceOrder(
    CommonRequestModel getRequest,
  ) async {
    throw UnimplementedError();
    // if (await networkInfo.isConnected) {
    //   try {
    //     final response = await remoteDataSource.getPlaceOrder(getRequest);
    //     return Right(response);
    //   } on ServerException catch (e) {
    //     return Left(ServerFailure(message: e.message));
    //   }
    // } else {
    //   return const Left(NetworkFailure(message: 'No internet connection'));
    // }
  }

  @override
  Future<Either<Failure, PlaceOrderResponse>> updatePlaceOrder(
    CommonRequestModel request,
  ) {
    // TODO: implement updatePlaceOrder
    throw UnimplementedError();
  }
}
