import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/my_orders/my_orders_response.dart';
import '../../domain/repository/my_orders_repository.dart';
import '../remote/datasources/my_orders_remote_datasource.dart';

class MyOrdersRepositoryImpl implements MyOrdersRepository {
  final MyOrdersRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  MyOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MyOrdersResponse>>> getMyOrdersById(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getOrderById(getRequest);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<MyOrdersResponse>>> getMyOrdersByMobile(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getOrderByMobile(getRequest);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
