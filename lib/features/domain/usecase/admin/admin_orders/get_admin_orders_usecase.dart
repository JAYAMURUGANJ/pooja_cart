// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../data/remote/model/request/common_request_model.dart';
import '../../../entities/admin/admin_orders/admin_orders_response.dart';
import '../../../repository/admin/admin_orders_repository.dart';

class GetAdminOrdersUseCase
    implements UseCase<List<AdminOrdersResponse>, CommonRequestModel> {
  final AdminOrdersRepository repository;

  GetAdminOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<AdminOrdersResponse>>> call(
    CommonRequestModel params,
  ) async {
    var result = await repository.getAdminOrders(params);
    print("result is $result");
    return result;
  }
}
