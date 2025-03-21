import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../data/remote/model/common_request_model.dart';
import '../entities/product/product_response.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductResponse>>> getProduct(
    CommonRequestModel getRequest,
  );
  Future<Either<Failure, ProductResponse>> createProduct(
    CommonRequestModel request,
  );
  Future<Either<Failure, ProductResponse>> updateProduct(
    CommonRequestModel request,
  );
  Future<Either<Failure, String>> deleteProduct(CommonRequestModel request);
}
