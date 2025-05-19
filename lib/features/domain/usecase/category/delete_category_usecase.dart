// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../repository/category_repository.dart';

class DeleteCategoryUseCase implements UseCase<String, CommonRequestModel> {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CommonRequestModel params) async {
    return await repository.deleteCategory(params);
  }
}
