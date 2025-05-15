import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/product/product_response.dart';
import '../../domain/repository/product_repository.dart';
import '../remote/datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, ProductResponse>> createProduct(
    CommonRequestModel request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.createProduct(request);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct(CommonRequestModel request) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProductResponse>>> getProduct(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getProducts(getRequest,);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductResponse>> updateProduct(
    CommonRequestModel request,
  ) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
