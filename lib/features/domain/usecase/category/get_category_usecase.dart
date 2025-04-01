// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../entities/category/category_response.dart';
import '../../repository/category_repository.dart';

class GetCategoryUseCase
    implements UseCase<List<CategoryResponse>, CommonRequestModel> {
  final CategoryRepository repository;

  GetCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryResponse>>> call(
    CommonRequestModel params,
  ) async {
    return await repository.getCategory(params);
  }
}
