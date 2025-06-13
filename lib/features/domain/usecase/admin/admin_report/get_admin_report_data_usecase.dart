// lib/features/posts/domain/usecases/create_post.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../data/remote/model/request/common_request_model.dart';
import '../../../entities/admin/admin_report/admin_report_response.dart';
import '../../../repository/admin/admin_report_repository.dart';

class GetAdminReportDataUseCase
    implements UseCase<AdminReportResponse, CommonRequestModel> {
  final AdminReportRepository repository;

  GetAdminReportDataUseCase(this.repository);

  @override
  Future<Either<Failure, AdminReportResponse>> call(
    CommonRequestModel params,
  ) async {
    var result = await repository.getReportData(params);
    return result;
  }
}
