// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../data/remote/model/request/common_request_model.dart';
import '../../../entities/admin/admin_dashboard/admin_dashboard_response.dart';
import '../../../repository/admin/admin_dashboard_repository.dart';

class GetAdminDashboardDataUseCase
    implements UseCase<AdminDashboardResponse, CommonRequestModel> {
  final AdminDashboardRepository repository;

  GetAdminDashboardDataUseCase(this.repository);

  @override
  Future<Either<Failure, AdminDashboardResponse>> call(
    CommonRequestModel params,
  ) async {
    var result = await repository.getDashboardData(params);
    return result;
  }
}
