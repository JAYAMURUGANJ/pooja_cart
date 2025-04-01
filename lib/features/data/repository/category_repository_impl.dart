import 'package:dartz/dartz.dart';
import 'package:pooja_cart/core/errors/failures.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/category/category_response.dart';
import '../../domain/repository/category_repository.dart';
import '../remote/datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, CategoryResponse>> createCategory(
    CommonRequestModel request,
  ) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> deleteCategory(CommonRequestModel request) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<CategoryResponse>>> getCategory(
    CommonRequestModel getRequest,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getCategory(getRequest);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, CategoryResponse>> updateCategory(
    CommonRequestModel request,
  ) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }
}
