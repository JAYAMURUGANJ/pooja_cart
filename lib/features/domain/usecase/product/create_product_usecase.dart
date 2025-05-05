// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../entities/product/product_response.dart';
import '../../repository/product_repository.dart';

class CreateProductUseCase
    implements UseCase<ProductResponse, CommonRequestModel> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductResponse>> call(
    CommonRequestModel params,
  ) async {
    return await repository.createProduct(params);
  }
}
