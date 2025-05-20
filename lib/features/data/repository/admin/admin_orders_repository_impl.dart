import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/datasources/admin/admin_orders_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_orders/admin_orders_response.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/repository/admin/admin_orders_repository.dart';

class AdminOrdersRepositoryImpl implements AdminOrdersRepository {
  final AdminOrdersRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  AdminOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, AdminOrdersResponse>> createAdminOrder(
    CommonRequestModel request,
  ) {
    // TODO: implement createAdminOrder
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> deleteAdminOrder(
    CommonRequestModel request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.deleteAdminOrder(request);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<AdminOrdersResponse>>> getAdminOrders(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        print("inside repository");
        final response = await remoteDataSource.getAdminOrders(getRequest);
        print("response is $response");
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AdminOrdersResponse>> updateAdminOrder(
    CommonRequestModel request,
  ) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
