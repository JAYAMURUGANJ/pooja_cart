// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/common_request_model.dart';
import '../../entities/product/product_response.dart';
import '../../repository/product_repository.dart';

class GetProductUseCase
    implements UseCase<List<ProductResponse>, CommonRequestModel> {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductResponse>>> call(
    CommonRequestModel params,
  ) async {
    return await repository.getProduct(params);
  }
}
