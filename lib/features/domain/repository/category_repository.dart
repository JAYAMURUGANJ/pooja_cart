import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/remote/model/common_request_model.dart';
import '../entities/category/category_response.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryResponse>>> getCategory(
    CommonRequestModel getRequest,
  );
  Future<Either<Failure, CategoryResponse>> createCategory(
    CommonRequestModel request,
  );
  Future<Either<Failure, CategoryResponse>> updateCategory(
    CommonRequestModel request,
  );
  Future<Either<Failure, String>> deleteCategory(CommonRequestModel request);
}
