import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../data/remote/model/request/common_request_model.dart';
import '../../entities/admin/admin_report/admin_report_response.dart';

abstract class AdminReportRepository {
  Future<Either<Failure, AdminReportResponse>> getReportData(
    CommonRequestModel getRequest,
  );
}
