import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/datasources/unit_remote_datasource.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';
import 'package:pooja_cart/features/domain/repository/units_repository.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  final UnitRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  UnitsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, UnitResponse>> createUnit(CommonRequestModel request) {
    // TODO: implement createUnit
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> deleteUnit(CommonRequestModel request) {
    // TODO: implement deleteUnit
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UnitResponse>>> getUnit(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUnits(getRequest);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UnitResponse>> updateUnit(CommonRequestModel request) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }
}
