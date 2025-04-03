// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../entities/my_orders/my_orders_response.dart';
import '../../repository/my_orders_repository.dart';

class GetMyOrdersByIdUseCase
    implements UseCase<List<MyOrdersResponse>, CommonRequestModel> {
  final MyOrdersRepository repository;

  GetMyOrdersByIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyOrdersResponse>>> call(
    CommonRequestModel params,
  ) async {
    return await repository.getMyOrdersById(params);
  }
}
